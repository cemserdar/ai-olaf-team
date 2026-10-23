<#
.SYNOPSIS
    AI Olaf Team - Seçici Hafıza Getirme Motoru (Selective Memory Retrieval)
.DESCRIPTION
    Ajan çağrılarında tüm hafıza dosyalarını baştan sona yüklemek yerine,
    yalnızca görev için gerekli bölümü (section) on-demand çeker.
    Context token tüketimini %70-%88 oranında azaltır.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [Alias("f")]
    [string]$File,

    [Parameter(Position = 1)]
    [Alias("s")]
    [string]$Section,

    [Alias("t")]
    [string]$Task,

    [Alias("a")]
    [string]$Agent,

    [switch]$Full,

    [Alias("MaxAge")]
    [int]$MaxAgeDays = 0,

    [Alias("l")]
    [switch]$ListSections,

    [string]$RootPath = ""
)

$ErrorActionPreference = "Stop"

function Emit-ErrorAndExit([string]$msg) {
    [Console]::Error.WriteLine($msg)
    Write-Output $msg
    exit 1
}

# 1. GÜVENLİK KONTROLÜ - Path Traversal Koruması
if ([string]::IsNullOrWhiteSpace($File)) {
    Emit-ErrorAndExit "HATA: Dosya parametresi (-File) belirtilmelidir."
}

if ($File -match '\.\.' -or $File -match '^(\/|\\|[a-zA-Z]:\\)' -or $File -match '[\*\?\"<>\|]') {
    if ($File -match '\.\.' -or $File -match '^/etc' -or $File -match '^c:[\\/]windows' -or $File -match '^/var') {
        Emit-ErrorAndExit "HATA: İzin verilmeyen dosya yolu: $File"
    }
}

# 2. PROJE KÖK DİZİNİ TESPİTİ
if ([string]::IsNullOrWhiteSpace($RootPath)) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    if (Test-Path (Join-Path $scriptDir "..\templates")) {
        $RootPath = (Resolve-Path (Join-Path $scriptDir "..")).Path
    } else {
        $RootPath = (Get-Location).Path
    }
} else {
    if (-not (Test-Path $RootPath)) {
        Emit-ErrorAndExit "HATA: Belirtilen kök dizin mevcut değil: $RootPath"
    }
    $RootPath = (Resolve-Path $RootPath).Path
}

$normalizedRoot = $RootPath.TrimEnd('\', '/')

# 3. DOSYA HEDEFİ ÇÖZÜMLEME (FILE ALIAS RESOLUTION)
$cleanAgent = if ($Agent) { $Agent.TrimStart('@') } else { "" }
$cleanTask = if ($Task) { $Task.ToUpper() } else { "" }

$resolvedFilePath = $null
$fileDisplayName = $File

switch -Regex ($File.ToLower()) {
    '^(brain|project-brain|project-brain\.md)$' {
        $fileDisplayName = "project-brain.md"
        $primary = Join-Path $normalizedRoot ".olaf\memory\project-brain.md"
        $fallback = Join-Path $normalizedRoot "templates\project-brain-template.md"
        if (Test-Path -LiteralPath $primary) { $resolvedFilePath = $primary }
        elseif (Test-Path -LiteralPath $fallback) { $resolvedFilePath = $fallback }
    }
    '^(sprint|active-sprint|active-sprint\.md)$' {
        $fileDisplayName = "active-sprint.md"
        $primary = Join-Path $normalizedRoot ".olaf\memory\active-sprint.md"
        $fallback = Join-Path $normalizedRoot "templates\active-sprint-template.md"
        if (Test-Path -LiteralPath $primary) { $resolvedFilePath = $primary }
        elseif (Test-Path -LiteralPath $fallback) { $resolvedFilePath = $fallback }
    }
    '^(skills|skill|learned-skills)$' {
        if ([string]::IsNullOrWhiteSpace($cleanAgent)) {
            Emit-ErrorAndExit "HATA: Skills sorgusu için -Agent parametresi gereklidir. Örn: -Agent backend"
        }
        $fileDisplayName = "$cleanAgent-skills.md"
        $primary = Join-Path $normalizedRoot ".olaf\learned-skills\$cleanAgent-skills.md"
        $fallback = Join-Path $normalizedRoot "templates\learned-skill-template.md"
        if (Test-Path -LiteralPath $primary) { $resolvedFilePath = $primary }
        elseif (Test-Path -LiteralPath $fallback) { $resolvedFilePath = $fallback }
    }
    '^(brief|context|task-context)$' {
        if ([string]::IsNullOrWhiteSpace($cleanTask)) {
            Emit-ErrorAndExit "HATA: Brief sorgusu için -Task parametresi gereklidir. Örn: -Task TASK-01"
        }
        $fileDisplayName = "$cleanTask-brief.md"
        $primary = Join-Path $normalizedRoot ".olaf\contexts\$cleanTask-brief.md"
        $fallback = Join-Path $normalizedRoot "templates\task-context-brief-template.md"
        if (Test-Path -LiteralPath $primary) { $resolvedFilePath = $primary }
        elseif (Test-Path -LiteralPath $fallback) { $resolvedFilePath = $fallback }
    }
    '^(output|task-output)$' {
        if ([string]::IsNullOrWhiteSpace($cleanTask)) {
            Emit-ErrorAndExit "HATA: Output sorgusu için -Task parametresi gereklidir. Örn: -Task TASK-01"
        }
        $fileDisplayName = "$cleanTask-output.md"
        $primary = Join-Path $normalizedRoot ".olaf\outputs\$cleanTask-output.md"
        $fallback = Join-Path $normalizedRoot "templates\task-output-template.md"
        if (Test-Path -LiteralPath $primary) { $resolvedFilePath = $primary }
        elseif (Test-Path -LiteralPath $fallback) { $resolvedFilePath = $fallback }
    }
    default {
        $candidatePath = Join-Path $normalizedRoot $File
        try {
            $fullCandidate = [System.IO.Path]::GetFullPath($candidatePath)
            if (-not $fullCandidate.StartsWith($normalizedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                Emit-ErrorAndExit "HATA: İzin verilmeyen dosya yolu: $File"
            }
            $allowedOlaf = Join-Path $normalizedRoot ".olaf"
            $allowedTemplates = Join-Path $normalizedRoot "templates"
            if ((-not $fullCandidate.StartsWith($allowedOlaf, [System.StringComparison]::OrdinalIgnoreCase)) -and
                (-not $fullCandidate.StartsWith($allowedTemplates, [System.StringComparison]::OrdinalIgnoreCase))) {
                Emit-ErrorAndExit "HATA: İzin verilmeyen dosya yolu: $File"
            }
            if (Test-Path -LiteralPath $fullCandidate) {
                $resolvedFilePath = $fullCandidate
                $fileDisplayName = Split-Path -Leaf $fullCandidate
            }
        } catch {
            Emit-ErrorAndExit "HATA: İzin verilmeyen dosya yolu: $File"
        }
    }
}

if (-not $resolvedFilePath -or -not (Test-Path -LiteralPath $resolvedFilePath)) {
    Emit-ErrorAndExit "HATA: Hedef hafıza dosyası bulunamadı: $File"
}

# 4. DOSYA İÇERİĞİNİ OKU
$fileLines = [System.IO.File]::ReadAllLines($resolvedFilePath, [System.Text.Encoding]::UTF8)

# 5. GERİYE DÖNÜK UYUMLULUK: --full
if ($Full) {
    Write-Output $fileLines
    exit 0
}

# 6. BÖLÜM LİSTELEME: --list
if ($ListSections) {
    Write-Host "📂 Mevcut Bölüm Anahtarları ($fileDisplayName):"
    $foundKeys = @()
    foreach ($line in $fileLines) {
        if ($line -match '^##\s+KEY:\s*([a-zA-Z0-9_\-]+)') {
            $foundKeys += $matches[1]
            Write-Host "  - $($matches[1])"
        }
    }
    if ($foundKeys.Count -eq 0) {
        Write-Host "  (Tanımlı ## KEY: etiketi bulunamadı)"
    }
    exit 0
}

# 7. SPRINT GÖREV SATIRI ÇEKME (--task ile active-sprint sorgusu)
if ($File -match '^(sprint|active-sprint|active-sprint\.md)$' -and (-not [string]::IsNullOrWhiteSpace($cleanTask)) -and [string]::IsNullOrWhiteSpace($Section)) {
    $headerLine = $null
    $separatorLine = $null
    $taskRow = $null

    for ($i = 0; $i -lt $fileLines.Count; $i++) {
        $curLine = $fileLines[$i]
        if ($curLine -match '^\|\s*Kulvar\s*\/\s*Faz') {
            $headerLine = $curLine
            if ($i + 1 -lt $fileLines.Count) {
                $separatorLine = $fileLines[$i + 1]
            }
        }
        if ($curLine -match "\|\s*`?$cleanTask`?\s*\|") {
            $taskRow = $curLine
        }
    }

    if ($taskRow) {
        Write-Host "## SPRINT GÖREVİ: $cleanTask"
        if ($headerLine) { Write-Host $headerLine }
        if ($separatorLine) { Write-Host $separatorLine }
        Write-Host $taskRow
        exit 0
    }
}

# 8. BÖLÜM (SECTION) SORGULAMA
if ([string]::IsNullOrWhiteSpace($Section) -and [string]::IsNullOrWhiteSpace($cleanTask)) {
    Emit-ErrorAndExit "HATA: Lütfen getirmek istediğiniz bölümü (-Section) veya görevi (-Task) belirtin. Tam dosya için: -Full"
}

$targetKey = if ($Section) { $Section.Trim() } else { $cleanTask }

$sectionStartIndex = -1
$sectionEndIndex = -1
$detectedKey = $null

for ($i = 0; $i -lt $fileLines.Count; $i++) {
    $line = $fileLines[$i]
    if ($line -match '^##\s+KEY:\s*([a-zA-Z0-9_\-]+)') {
        $currentKey = $matches[1].Trim()
        if ($sectionStartIndex -eq -1) {
            if ($currentKey -eq $targetKey -or $currentKey.ToLower() -eq $targetKey.ToLower()) {
                $sectionStartIndex = $i
                $detectedKey = $currentKey
                continue
            }
        } else {
            $sectionEndIndex = $i - 1
            break
        }
    } elseif ($sectionStartIndex -ne -1 -and $line -match '^##\s+[^#]') {
        $sectionEndIndex = $i - 1
        break
    }
}

# Fallback anahtar arama
if ($sectionStartIndex -eq -1) {
    $aliasPattern = switch -Regex ($targetKey.ToLower()) {
        'tech-stack'      { 'TEKNOLOJİ YIĞINI' }
        'overview'        { 'PROJE KİMLİĞİ' }
        'architecture'    { 'MİMARİ YAPI' }
        'database'        { 'VERİTABANI' }
        'api'             { 'API STANDARTLARI' }
        'security'        { 'GÜVENLİK' }
        'devops'          { 'DEVOPS' }
        'git-history'     { 'GİT GEÇMİŞİ' }
        'team-agreement'  { 'TAKIM ANLAŞMASI' }
        'sprint-goal'     { 'SPRINT HEDEFİ' }
        'task-board'      { 'GÖREV DAĞILIMI' }
        'conventions'     { 'KODLAMA VE TASARIM STANDARTLARI' }
        'models'          { 'İLİŞKİLİ VERİ' }
        'anti-patterns'   { 'ASLA YAPILMAYACAKLAR|DİKKAT EDİLECEK' }
        'checklist'       { 'ZORUNLU YAPILACAKLAR|KONTROL LİSTESİ' }
        'acceptance'      { 'GÖREV TANIMI VE KABUL KRİTERLERİ' }
        'scope'           { 'DOSYA KAPSAMI' }
        'dependencies'    { 'BAĞIMLILIKLAR' }
        'output'          { 'TESLİMAT VE ÇIKTI' }
        default           { [regex]::Escape($targetKey) }
    }

    for ($i = 0; $i -lt $fileLines.Count; $i++) {
        $line = $fileLines[$i]
        if ($line -match "^##\s+.*$aliasPattern") {
            $sectionStartIndex = $i
            $detectedKey = $targetKey
            for ($j = $i + 1; $j -lt $fileLines.Count; $j++) {
                if ($fileLines[$j] -match '^##\s+') {
                    $sectionEndIndex = $j - 1
                    break
                }
            }
            break
        }
    }
}

if ($sectionStartIndex -eq -1) {
    Emit-ErrorAndExit "HATA: '$targetKey' bölümü '$fileDisplayName' içinde bulunamadı."
}

if ($sectionEndIndex -eq -1) {
    $sectionEndIndex = $fileLines.Count - 1
}

$sectionLines = @()
for ($i = $sectionStartIndex; $i -le $sectionEndIndex; $i++) {
    $sectionLines += $fileLines[$i]
}
$sectionText = $sectionLines -join "`n"

# 9. GÜNCELLİK KONTROLÜ (--max-age)
if ($MaxAgeDays -gt 0) {
    $foundDate = $null
    if ($sectionText -match '<!--\s*updated:\s*(\d{4}-\d{2}-\d{2})') {
        try { $foundDate = [DateTime]::ParseExact($matches[1], 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture) } catch {}
    } elseif ($sectionText -match '<!--\s*updated:\s*(\d{2}\.\d{2}\.\d{4})') {
        try { $foundDate = [DateTime]::ParseExact($matches[1], 'dd.MM.yyyy', [System.Globalization.CultureInfo]::InvariantCulture) } catch {}
    }

    if (-not $foundDate) {
        $fullText = $fileLines -join "`n"
        if ($fullText -match 'Son Güncelleme:\*\*\s*(\d{4}-\d{2}-\d{2})') {
            try { $foundDate = [DateTime]::ParseExact($matches[1], 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture) } catch {}
        } elseif ($fullText -match 'Son Güncelleme:\*\*\s*(\d{2}\.\d{2}\.\d{4})') {
            try { $foundDate = [DateTime]::ParseExact($matches[1], 'dd.MM.yyyy', [System.Globalization.CultureInfo]::InvariantCulture) } catch {}
        }
    }

    if (-not $foundDate) {
        $foundDate = (Get-Item -LiteralPath $resolvedFilePath).LastWriteTime
    }

    if ($foundDate) {
        $ageDays = [Math]::Floor(((Get-Date) - $foundDate).TotalDays)
        if ($ageDays -gt $MaxAgeDays) {
            Write-Host "⚠️  UYARI: $fileDisplayName §$detectedKey $ageDays günden eski (son güncelleme: $($foundDate.ToString('yyyy-MM-dd')))"
        }
    }
}

# 10. ÇIKTIYI YAZDIR
Write-Output $sectionText
exit 0
