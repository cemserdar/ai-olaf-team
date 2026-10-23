<#
.SYNOPSIS
    AI Olaf Team - Seçici Hafıza Doğrulama Test Koşucusu (Test A - Test E)
.DESCRIPTION
    ADR-11 ila ADR-14 standartlarını doğrular:
    - Test A: Token ve satır tasarrufu (seçici getirme <= %30)
    - Test B: Hedef bölümün doğru ve izole getirilmesi
    - Test C: Güncellik uyarısı mekanizması
    - Test D: Dizin dışına çıkış (Path Traversal) güvenlik engeli
    - Test E: --full bayrağı ile geriye dönük tam yükleme uyumluluğu
#>
[CmdletBinding()]
param()

$cReset  = "`e[0m"
$cBold   = "`e[1m"
$cCyan   = "`e[36m"
$cGreen  = "`e[32m"
$cYellow = "`e[33m"
$cRed    = "`e[31m"

Write-Host "`n$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    🧪 AI OLAF TEAM - SEÇİCİ HAFIZA (SELECTIVE RETRIEVAL) TESTLERİ$cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset`n"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$queryScript = Join-Path $scriptDir "olaf-query-memory.ps1"
$projectRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
$templateBrain = Join-Path $projectRoot "templates\project-brain-template.md"

if (-not (Test-Path $queryScript)) {
    Write-Host "$cRed[BAŞARISIZ] olaf-query-memory.ps1 bulunamadı: $queryScript$cReset"
    exit 1
}

$passCount = 0
$failCount = 0

function Report-Result($name, $passed, $details) {
    if ($passed) {
        $script:passCount++
        Write-Host "$cGreen[GEÇTİ] $name$cReset"
        if ($details) { Write-Host "        $details" }
    } else {
        $script:failCount++
        Write-Host "$cRed[BAŞARISIZ] $name$cReset"
        if ($details) { Write-Host "        $cYellow$details$cReset" }
    }
}

# --- TEST A: Token & Satır Tasarrufu (<= %30) ---
Write-Host "$cBold▶ Test A: Token & Satır Tasarrufu Ölçümü$cReset"
$fullLines = [System.IO.File]::ReadAllLines($templateBrain).Count
$selectiveOutput = & powershell -ExecutionPolicy Bypass -File $queryScript -File brain -Section tech-stack
$selectiveLines = ($selectiveOutput -join "`n" -split "`r?`n").Count
$ratio = [Math]::Round(($selectiveLines / $fullLines) * 100, 1)

$testAPassed = ($selectiveLines -le ($fullLines * 0.30))
Report-Result "Test A - Token Tasarrufu" $testAPassed "Tam dosya: $fullLines satır | Seçici: $selectiveLines satır (Oran: %$ratio - Hedef: <= %30)"

# --- TEST B: Doğru Bölüm Getirme & İzolasyon ---
Write-Host "`n$cBold▶ Test B: Doğru Bölüm İzolasyonu$cReset"
$resultB = & powershell -ExecutionPolicy Bypass -File $queryScript -File brain -Section tech-stack
$hasTechStack = ($resultB -match "## KEY: tech-stack")
$notHasArch = (-not ($resultB -match "## KEY: architecture"))

$testBPassed = ($hasTechStack -and $notHasArch)
Report-Result "Test B - Bölüm İzolasyonu" $testBPassed "Hedef KEY bulundu: $hasTechStack | İlgisiz KEY izole edildi: $notHasArch"

# --- TEST C: Güncellik (Freshness) Uyarısı ---
Write-Host "`n$cBold▶ Test C: Güncellik (Freshness) Uyarısı$cReset"
$resultC = & powershell -ExecutionPolicy Bypass -File $queryScript -File brain -Section tech-stack -MaxAgeDays 7
$hasWarning = ($resultC -match "⚠️  UYARI")

$testCPassed = $hasWarning
Report-Result "Test C - Güncellik Uyarısı" $testCPassed "8 günlük tech-stack bölümü için '--max-age 7' uyarısı tetiklendi: $hasWarning"

# --- TEST D: Sınır Dışı Güvenlik (Path Traversal) ---
Write-Host "`n$cBold▶ Test D: Güvenlik Sınırı & Traversal Engelleme$cReset"
$outputD = & powershell -ExecutionPolicy Bypass -File $queryScript -File "../../etc/passwd" -Section all 2>&1
$exitCode = $LASTEXITCODE
$testDPassed = (($outputD -join " ") -match "HATA: İzin verilmeyen dosya yolu" -and $exitCode -eq 1)

Report-Result "Test D - Dizin Kaçış Güvenliği" $testDPassed "Çıkış Kodu: $exitCode (Beklenen: 1) | Traversal engellendi: $testDPassed"

# --- TEST E: Geriye Dönük Uyumluluk (--full) ---
Write-Host "`n$cBold▶ Test E: Geriye Dönük Uyumluluk (--full)$cReset"
$resultE = & powershell -ExecutionPolicy Bypass -File $queryScript -File brain -Full
$fullOutputLines = @($resultE).Count
$testEPassed = ($fullOutputLines -eq $fullLines)

Report-Result "Test E - Tam Yükleme Uyumluluğu" $testEPassed "Beklenen: $fullLines satır | Alınan: $fullOutputLines satır"

# --- ÖZET RAPOR ---
Write-Host "`n$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    TEST ÖZETİ: $passCount GEÇTİ, $failCount BAŞARISIZ$cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset`n"

if ($failCount -gt 0) {
    exit 1
} else {
    exit 0
}
