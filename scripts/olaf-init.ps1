<#
==============================================================================
AI OLAF TEAM - OTONOM YAZILIM TAKIMI PROJE ENTEGRASYON MOTORU (olaf-init.ps1)
==============================================================================
Bu PowerShell betiği, çalıştırıldığı herhangi bir projeye "AI Olaf Team" 15
kişilik otonom ekibini bağlar, projenin röntgenini çeker, hafıza ve kural
köprülerini Windows ortamında kurar.
==============================================================================
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

# UTF-8 Konsol Çıktısı Uyumluluğu (Windows PowerShell 5.1 & PowerShell 7+)
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {}
$OutputEncoding = [System.Text.Encoding]::UTF8

# ANSI Renk Kodları veya Düz Metin Uyumluluğu (Windows PowerShell 5.1 & Terminal)
$supportsAnsi = $false
try {
    if ($Host.UI.SupportsVirtualTerminal -or $env:WT_SESSION -or $env:TERM_PROGRAM) {
        $supportsAnsi = $true
    }
} catch {
    $supportsAnsi = $false
}

if ($supportsAnsi) {
    $esc = [char]27
    $cReset = "$esc[0m"
    $cBold = "$esc[1m"
    $cCyan = "$esc[36m"
    $cGreen = "$esc[32m"
    $cYellow = "$esc[33m"
    $cBlue = "$esc[34m"
    $cRed = "$esc[31m"
} else {
    $cReset = ""
    $cBold = ""
    $cCyan = ""
    $cGreen = ""
    $cYellow = ""
    $cBlue = ""
    $cRed = ""
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

Write-Host "$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    🚀 AI OLAF TEAM - OTONOM YAZILIM TAKIMI ENTEGRASYON MOTORU (WINDOWS)$cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset"

# 1. AI OLAF TEAM MERKEZİ REPO DİZİNİNİ TESPİT ET
$olafCentralDir = $null

$scriptPath = if ($PSScriptRoot) {
    $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} elseif ($MyInvocation.MyCommand.Definition) {
    Split-Path -Parent $MyInvocation.MyCommand.Definition
} else {
    $null
}

$parentScriptDir = if ($scriptPath) { Split-Path -Parent $scriptPath } else { $null }

$candidates = @(
    $env:AI_OLAF_TEAM_DIR,
    [Environment]::GetEnvironmentVariable("AI_OLAF_TEAM_DIR", "User"),
    $parentScriptDir,
    "$HOME\ai-olaf-team",
    "$HOME\Desktop\ai-olaf-team",
    "$HOME\Masaüstü\ai-olaf-team"
)

foreach ($c in $candidates) {
    if ($c -and (Test-Path -LiteralPath (Join-Path $c "base-agents"))) {
        $olafCentralDir = (Resolve-Path -LiteralPath $c).Path
        break
    }
}

if (-not $olafCentralDir -or -not (Test-Path -LiteralPath (Join-Path $olafCentralDir "base-agents"))) {
    Write-Host "$cRed❌ HATA: AI Olaf Team merkezi repo dizini bulunamadı!$cReset"
    Write-Host "Lütfen repo dizinini şu şekilde belirtin: `$env:AI_OLAF_TEAM_DIR = 'C:\path\to\ai-olaf-team'"
    exit 1
}

Write-Host "$cGreen✓ Merkezi Ekip Dizini:$cReset $olafCentralDir"

$targetDir = (Get-Location).Path
$projectName = Split-Path -Leaf $targetDir

Write-Host "$cGreen✓ Hedef Proje Dizini:$cReset  $targetDir"
Write-Host "$cGreen✓ Hedef Proje Adı:$cReset     $projectName"

# 2. .olaf DİZİN YAPISINI OLUŞTUR
Write-Host "`n$cBlue📂 .olaf Hafıza ve Yetenek Dizinleri Oluşturuluyor...$cReset"
$olafDir = Join-Path $targetDir ".olaf"
$baseAgentsDir = Join-Path $olafDir "base-agents"
$learnedSkillsDir = Join-Path $olafDir "learned-skills"
$memoryDir = Join-Path $olafDir "memory"

New-Item -ItemType Directory -Force -Path $baseAgentsDir | Out-Null
New-Item -ItemType Directory -Force -Path $learnedSkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $memoryDir | Out-Null

# Merkezi base-agents dosyalarını hedef projeye kopyala
$baseAgentsSource = Join-Path $olafCentralDir "base-agents"
Get-ChildItem -LiteralPath $baseAgentsSource -Filter "*.md" -File | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $baseAgentsDir -Force
}

# 3. 15 AJAN İÇİN LEARNED-SKILLS DOSYALARINI BAŞLAT
$agentsList = @(
    @{ Key = "pm"; Role = "Proje Yöneticisi & Takım Orkestra Şefi"; Tag = "@pm" },
    @{ Key = "architect"; Role = "Baş Yazılım Mimarı"; Tag = "@architect" },
    @{ Key = "ba"; Role = "İş Analisti & Product Owner"; Tag = "@ba" },
    @{ Key = "backend"; Role = "Kıdemli Backend Uzmanı"; Tag = "@backend" },
    @{ Key = "db"; Role = "Veritabanı ve ORM Uzmanı"; Tag = "@db" },
    @{ Key = "realtime"; Role = "Gerçek Zamanlı Sistemler ve Worker Uzmanı"; Tag = "@realtime" },
    @{ Key = "frontend"; Role = "Kıdemli Web Frontend Uzmanı"; Tag = "@frontend" },
    @{ Key = "mobile"; Role = "Cross-Platform Mobil Uzmanı"; Tag = "@mobile" },
    @{ Key = "uiux"; Role = "UI/UX Tasarım ve Ergonomi Uzmanı"; Tag = "@uiux" },
    @{ Key = "security"; Role = "Siber Güvenlik & AppSec Uzmanı"; Tag = "@security" },
    @{ Key = "devops"; Role = "DevOps, Linux ve CI/CD Uzmanı"; Tag = "@devops" },
    @{ Key = "qa"; Role = "Kalite Güvence ve Test Uzmanı"; Tag = "@qa" },
    @{ Key = "refactor"; Role = "Clean Code ve Performans Uzmanı"; Tag = "@refactor" },
    @{ Key = "docs"; Role = "Teknik Yazar ve Dokümantasyon Uzmanı"; Tag = "@docs" },
    @{ Key = "legal"; Role = "Bilişim Hukuku ve Lisans Uzmanı"; Tag = "@legal" }
)

$templateSkillPath = Join-Path $olafCentralDir "templates\learned-skill-template.md"
$currentDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

if (Test-Path -LiteralPath $templateSkillPath) {
    $templateSkillContent = [System.IO.File]::ReadAllText($templateSkillPath, [System.Text.Encoding]::UTF8)
    foreach ($agent in $agentsList) {
        $skillFile = Join-Path $learnedSkillsDir "$($agent.Key)-skills.md"
        if (-not (Test-Path -LiteralPath $skillFile)) {
            $content = $templateSkillContent.Replace("{{AGENT_NAME}}", "$($agent.Key.ToUpper()) AGENT")
            $content = $content.Replace("{{AGENT_ROLE}}", $agent.Role)
            $content = $content.Replace("{{AGENT_TAG}}", $agent.Tag)
            $content = $content.Replace("{{LAST_UPDATED}}", $currentDate)
            $content = $content.Replace("{{TRAINING_STATUS}}", "EĞİTİM BEKLİYOR")
            [System.IO.File]::WriteAllText($skillFile, $content, $utf8NoBom)
        }
    }
}

# 4. ACTIVE SPRINT BAŞLAT
$activeSprintFile = Join-Path $memoryDir "active-sprint.md"
$templateSprintPath = Join-Path $olafCentralDir "templates\active-sprint-template.md"

if ((-not (Test-Path -LiteralPath $activeSprintFile)) -and (Test-Path -LiteralPath $templateSprintPath)) {
    $sprintContent = [System.IO.File]::ReadAllText($templateSprintPath, [System.Text.Encoding]::UTF8)
    $sprintContent = $sprintContent.Replace("{{SPRINT_TITLE}}", "Sprint 01 - Proje Kurulumu ve Başlangıç")
    $sprintContent = $sprintContent.Replace("{{SPRINT_START_DATE}}", $currentDate)
    $sprintContent = $sprintContent.Replace("{{SPRINT_GOAL}}", "Projenin analizi, mimari temelleri ve ilk sürüm hedefleri")
    [System.IO.File]::WriteAllText($activeSprintFile, $sprintContent, $utf8NoBom)
}

# 5. PROJE TÜRÜNÜ TESPİT ET (BROWNFIELD / GREENFIELD)
Write-Host "`n$cBlue🔍 Proje Röntgeni Çekiliyor ve Kod Taraması Yapılıyor...$cReset"

$sourceExtensions = @(
    "*.cs", "*.java", "*.kt", "*.kts", "*.dart", "*.swift", "*.m", "*.h", "*.cpp", "*.c",
    "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue", "*.svelte", "*.html",
    "*.py", "*.go", "*.rs", "*.php", "*.rb",
    "package.json", "pom.xml", "build.gradle*", "settings.gradle*", "*.csproj", "*.sln",
    "AndroidManifest.xml", "pubspec.yaml", "Cargo.toml", "go.mod", "requirements.txt",
    "Pipfile", "pyproject.toml", "composer.json", "Gemfile"
)
$excludeDirSet = @(".olaf", ".git", "node_modules", "bin", "obj", ".vs", "dist", "build", ".next", ".nuxt", "vendor", ".gradle", ".idea", "Pods", ".dart_tool")

$srcFiles = @()

try {
    # 1. Kök dizindeki dosyalar
    $rootFiles = Get-ChildItem -LiteralPath $targetDir -File -ErrorAction SilentlyContinue
    if ($rootFiles) {
        foreach ($file in $rootFiles) {
            foreach ($pattern in $sourceExtensions) {
                if ($file.Name -like $pattern) {
                    $srcFiles += $file
                    break
                }
            }
        }
    }

    # 2. Üst seviye alt dizinler (hariç tutulanlar taranmaz)
    $subDirs = Get-ChildItem -LiteralPath $targetDir -Directory -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notin $excludeDirSet -and $_.Name -notmatch "^\."
    }
    if ($subDirs) {
        foreach ($dir in $subDirs) {
            $subFiles = Get-ChildItem -LiteralPath $dir.FullName -Recurse -File -Depth 10 -ErrorAction SilentlyContinue
            if ($subFiles) {
                foreach ($file in $subFiles) {
                    $fullName = $file.FullName
                    $isExcluded = $false
                    foreach ($ex in $excludeDirSet) {
                        if ($fullName -match "[\\/]($([regex]::Escape($ex)))[\\/]") {
                            $isExcluded = $true
                            break
                        }
                    }
                    if (-not $isExcluded) {
                        foreach ($pattern in $sourceExtensions) {
                            if ($file.Name -like $pattern) {
                                $srcFiles += $file
                                break
                            }
                        }
                    }
                }
            }
        }
    }
} catch {
    # Tarama sırasında erişim hatası olursa akışı kesme
}

$srcCount = $srcFiles.Count
$isBrownfield = $srcCount -gt 0

# 6. RÖNTGEN ANALİZİ VE PROJECT BRAIN DOLDURMA
$detectedStack = ""
$trainingFlagFile = Join-Path $memoryDir "TRAINING_REQUIRED.flag"

if ($isBrownfield) {
    $projectType = "BROWNFIELD (Mevcut Kod Tabanı)"
    $trainingStatus = "EĞİTİM GEREKLİ (/olaf-train çalıştırılmalı)"
    Write-Host "$cYellow⚡ Proje Türü:$cReset $projectType ($srcCount kaynak dosya/paket tespit edildi)"
    
    [System.IO.File]::WriteAllText($trainingFlagFile, "Bu projede mevcut kaynak kodlar tespit edildi. Lütfen /olaf-train komutunu çalıştırarak 15 ajanı eğitin.`n", $utf8NoBom)
    
    Write-Host "$cBlue📋 Paket ve Teknoloji Analizi Yapılıyor...$cReset"
    
    # Android (Kotlin / Java / Gradle)
    $hasAndroidDir = Test-Path -LiteralPath (Join-Path $targetDir "android")
    $hasAppGradle = (Test-Path -LiteralPath (Join-Path $targetDir "app\build.gradle")) -or (Test-Path -LiteralPath (Join-Path $targetDir "android\app\build.gradle"))
    $hasManifest = (Get-ChildItem -LiteralPath $targetDir -Filter "AndroidManifest.xml" -Recurse -Depth 5 -ErrorAction SilentlyContinue | Select-Object -First 1)
    $hasKotlin = (Get-ChildItem -LiteralPath $targetDir -Filter "*.kt" -Recurse -Depth 8 -ErrorAction SilentlyContinue | Select-Object -First 1)

    if ($hasAndroidDir -or $hasAppGradle -or $hasManifest) {
        $lang = if ($hasKotlin) { "Kotlin (Android Native)" } else { "Java (Android Native)" }
        $detectedStack += "- Mobil: Android Projesi tespit edildi ($lang).`n"
        $detectedStack += "  * Gradle derleme altyapısı ve Android manifest mevcut.`n"
        if ($hasKotlin) {
            $detectedStack += "  * Diller: Kotlin (*.kt)`n"
        }
    }

    # Flutter
    if (Test-Path -LiteralPath (Join-Path $targetDir "pubspec.yaml")) {
        $detectedStack += "- Mobil/Cross-Platform: Flutter projesi tespit edildi (pubspec.yaml).`n"
    }

    # iOS / Swift
    if ((Test-Path -LiteralPath (Join-Path $targetDir "Podfile")) -or (Get-ChildItem -LiteralPath $targetDir -Filter "*.xcodeproj" -Depth 2 -ErrorAction SilentlyContinue)) {
        $detectedStack += "- Mobil: iOS Projesi tespit edildi (Xcode / CocoaPods).`n"
    }

    # .NET / C#
    $csprojFiles = Get-ChildItem -LiteralPath $targetDir -Filter "*.csproj" -Recurse -Depth 5 -ErrorAction SilentlyContinue | Select-Object -First 5
    $slnFiles = Get-ChildItem -LiteralPath $targetDir -Filter "*.sln" -Depth 2 -ErrorAction SilentlyContinue
    if ($csprojFiles -or $slnFiles) {
        $detectedStack += "- Backend: .NET / C# tespit edildi.`n"
        foreach ($csproj in $csprojFiles) {
            $relPath = if ($csproj.FullName.Length -gt $targetDir.Length) {
                $csproj.FullName.Substring($targetDir.Length).TrimStart('\', '/')
            } else {
                $csproj.Name
            }
            $detectedStack += "  * Proje: $relPath`n"
        }
    }
    
    # Node / Web / Mobil
    $pkgJsonPath = Join-Path $targetDir "package.json"
    if (Test-Path -LiteralPath $pkgJsonPath) {
        $detectedStack += "- JavaScript/TypeScript Ekosistemi tespit edildi (package.json).`n"
        $pkgContent = [System.IO.File]::ReadAllText($pkgJsonPath, [System.Text.Encoding]::UTF8)
        if ($pkgContent -match "react-native" -or $pkgContent -match "expo") {
            $detectedStack += "  * Mobil: React Native / Expo tespit edildi.`n"
        }
        if ($pkgContent -match '"react"') {
            $detectedStack += "  * Web: React tespit edildi.`n"
        } elseif ($pkgContent -match "@angular") {
            $detectedStack += "  * Web: Angular tespit edildi.`n"
        } elseif ($pkgContent -match '"vue"') {
            $detectedStack += "  * Web: Vue.js tespit edildi.`n"
        }
    }
    
    # Java (Maven / Gradle)
    if ((Test-Path -LiteralPath (Join-Path $targetDir "pom.xml")) -or (Test-Path -LiteralPath (Join-Path $targetDir "build.gradle")) -or (Test-Path -LiteralPath (Join-Path $targetDir "build.gradle.kts"))) {
        $detectedStack += "- Java Ekosistemi tespit edildi (Maven/Gradle).`n"
    }
    
    # Python
    if ((Test-Path -LiteralPath (Join-Path $targetDir "requirements.txt")) -or (Test-Path -LiteralPath (Join-Path $targetDir "pyproject.toml"))) {
        $detectedStack += "- Python Ekosistemi tespit edildi.`n"
    }
    
    # Go
    if (Test-Path -LiteralPath (Join-Path $targetDir "go.mod")) {
        $detectedStack += "- Backend: Go Ekosistemi tespit edildi (go.mod).`n"
    }

    # Rust
    if (Test-Path -LiteralPath (Join-Path $targetDir "Cargo.toml")) {
        $detectedStack += "- Sistem/Backend: Rust Ekosistemi tespit edildi (Cargo.toml).`n"
    }

    # PHP
    if (Test-Path -LiteralPath (Join-Path $targetDir "composer.json")) {
        $detectedStack += "- Web/Backend: PHP Ekosistemi tespit edildi (composer.json).`n"
    }

    # Docker
    if ((Test-Path -LiteralPath (Join-Path $targetDir "Dockerfile")) -or (Test-Path -LiteralPath (Join-Path $targetDir "docker-compose.yml"))) {
        $detectedStack += "- DevOps: Docker / Docker Compose mevcut.`n"
    }
    
    # GitHub Actions
    if (Test-Path -LiteralPath (Join-Path $targetDir ".github\workflows")) {
        $detectedStack += "- CI/CD: GitHub Actions iş akışları mevcut.`n"
    }
    
    # Klasör Özeti
    $treeItems = Get-ChildItem -LiteralPath $targetDir -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notmatch "^\." -and $_.Name -notin $excludeDirSet
    } | Select-Object -First 35
    $treeSummary = ($treeItems | ForEach-Object { $_.Name }) -join "`n"

} else {
    $projectType = "GREENFIELD (Sıfırdan Proje)"
    $trainingStatus = "HAZIR (Sıfırdan Mimari Başlatılabilir)"
    Write-Host "$cGreen🌱 Proje Türü:$cReset $projectType (Boş proje dizini)"
    if (Test-Path -LiteralPath $trainingFlagFile) { Remove-Item -LiteralPath $trainingFlagFile -Force }
    $detectedStack = "Henüz kod eklenmedi. Sıfırdan mimari kurgusu için @pm hazır bekliyor.`n"
    $treeSummary = "."
}

# project-brain.md dosyasını şablondan doldur
$templateBrainPath = Join-Path $olafCentralDir "templates\project-brain-template.md"
$brainFile = Join-Path $memoryDir "project-brain.md"

if (Test-Path -LiteralPath $templateBrainPath) {
    $brainContent = [System.IO.File]::ReadAllText($templateBrainPath, [System.Text.Encoding]::UTF8)
    $brainContent = $brainContent.Replace("{{PROJECT_NAME}}", $projectName)
    $brainContent = $brainContent.Replace("{{PROJECT_TYPE}}", $projectType)
    $brainContent = $brainContent.Replace("{{CREATED_AT}}", $currentDate)
    $brainContent = $brainContent.Replace("{{LAST_UPDATED}}", $currentDate)
    $brainContent = $brainContent.Replace("{{TRAINING_STATUS}}", $trainingStatus)
    $brainContent = $brainContent.Replace("{{PROJECT_GOAL}}", "$projectName projesinin hedefleri ve isterleri")
    $brainContent = $brainContent.Replace("{{TARGET_AUDIENCE}}", "Kullanıcılar ve Sistem İstemcileri")

    $codeFence = '```'
    $brainContent += @"

### 🔎 OLAF-INIT İLK RÖNTGEN BULGULARI:
$detectedStack
### 📁 TESPİT EDİLEN KLASÖR AĞACI:
$codeFence
$treeSummary
$codeFence
"@
    [System.IO.File]::WriteAllText($brainFile, $brainContent, $utf8NoBom)
}

# 7. ANTIGRAVITY VE VS CODE WORKFLOW KÖPRÜLERİNİ KUR
Write-Host "`n$cBlue🌉 Antigravity & IDE Slash Workflows (.agent/workflows & .agents/workflows) Kuruluyor...$cReset"
$agentWorkflowsDir1 = Join-Path $targetDir ".agent\workflows"
$agentWorkflowsDir2 = Join-Path $targetDir ".agents\workflows"

New-Item -ItemType Directory -Force -Path $agentWorkflowsDir1 | Out-Null
New-Item -ItemType Directory -Force -Path $agentWorkflowsDir2 | Out-Null

$workflowsToCopy = @("olaf-train.md", "pm.md", "sync-skills.md", "review-all.md")
foreach ($wf in $workflowsToCopy) {
    $srcWf = Join-Path $olafCentralDir "workflows\$wf"
    if (Test-Path -LiteralPath $srcWf) {
        Copy-Item -LiteralPath $srcWf -Destination (Join-Path $agentWorkflowsDir1 $wf) -Force
        Copy-Item -LiteralPath $srcWf -Destination (Join-Path $agentWorkflowsDir2 $wf) -Force
    }
}

# 8. ÇOKLU IDE MASTER KURAL KÖPRÜLERİNİ OLUŞTUR
Write-Host "$cBlue📜 Çoklu IDE Kural Köprüleri (GEMINI.md, AGENTS.md, .cursorrules vb.) Oluşturuluyor...$cReset"

$masterRules = @"
# 🤖 AI OLAF TEAM - MERKEZİ ORKESTRASYON VE AJAN PROTOKOLÜ

Bu proje **"AI Olaf Team"** 15 kişilik otonom yazılım ekibi tarafından yönetilmektedir.
Herhangi bir IDE'de (Antigravity IDE, VS Code Gemini Code Assist, GitHub Copilot, Cursor, Cline, Roo Code) çalışırken aşağıdaki protokole %100 uymak zorunludur:

---

## 🚨 ZORUNLU İLK ADIM: HAFIZA VE EĞİTİM KONTROLÜ
1. Kullanıcıdan gelen her mesajda, öncelikle `.olaf/memory/project-brain.md` dosyasını oku.
2. `.olaf/memory/TRAINING_REQUIRED.flag` dosyasının olup olmadığını kontrol et:
   - **EĞER VARSA:** Projenin eğitilmesi gerekmektedir. Kullanıcıya bildir veya doğrudan `/olaf-train` iş akışını çalıştırarak 15 ajanın `.olaf/learned-skills/<agent>-skills.md` dosyalarını projenin kodlarıyla doldur.
   - **EĞER YOKSA:** Normal operasyon modunda devam et.

---

## 👥 15 UZMAN AJAN VE ETİKET KULLANIMI
Kullanıcı `@etiket` kullandığında veya `@pm` bir alt ajana görev devrettiğinde, o ajanın hem sabit DNA'sı (`.olaf/base-agents/<agent>.md`) hem de projeye özel öğrenilmiş hafızası (`.olaf/learned-skills/<agent>-skills.md`) birlikte hafızaya yüklenmelidir:

- `@pm` -> Proje Yöneticisi & Orkestra Şefi (`.olaf/base-agents/01-pm-agent.md`)
- `@architect` -> Baş Yazılım Mimarı (`.olaf/base-agents/02-architect-agent.md`)
- `@ba` -> İş Analisti & Product Owner (`.olaf/base-agents/03-ba-agent.md`)
- `@backend` -> Kıdemli Backend Uzmanı (`.olaf/base-agents/04-backend-agent.md`)
- `@db` -> Veritabanı ve ORM Uzmanı (`.olaf/base-agents/05-db-agent.md`)
- `@realtime` -> Gerçek Zamanlı Sistemler ve Kuyruk Uzmanı (`.olaf/base-agents/06-realtime-agent.md`)
- `@frontend` -> Kıdemli Web Frontend Uzmanı (`.olaf/base-agents/07-frontend-agent.md`)
- `@mobile` -> Cross-Platform Mobil Uzmanı (`.olaf/base-agents/08-mobile-agent.md`)
- `@uiux` -> UI/UX Tasarım ve Tasarım Sistemi Uzmanı (`.olaf/base-agents/09-uiux-agent.md`)
- `@security` -> Siber Güvenlik & AppSec Uzmanı (`.olaf/base-agents/10-security-agent.md`)
- `@devops` -> DevOps, Docker ve CI/CD Uzmanı (`.olaf/base-agents/11-devops-agent.md`)
- `@qa` -> Kalite Güvence ve Test Otomasyon Uzmanı (`.olaf/base-agents/12-qa-agent.md`)
- `@refactor` -> Clean Code ve Performans Uzmanı (`.olaf/base-agents/13-refactor-agent.md`)
- `@docs` -> Teknik Yazar ve Dokümantasyon Uzmanı (`.olaf/base-agents/14-docs-agent.md`)
- `@legal` -> Bilişim Hukuku ve Lisans Uzmanı (`.olaf/base-agents/15-legal-agent.md`)

---

## 🔄 SÜREKLİ EĞİTİM (SELF-UPDATE) KURALI
Projede kod yazıldığında, bir bug çözüldüğünde veya yeni bir model eklendiğinde:
- Görevi tamamlayan ajan, görevi bitirmeden önce `.olaf/learned-skills/<agent>-skills.md` dosyasını günceller.
- `@pm` ise `.olaf/memory/project-brain.md` ve `.olaf/memory/active-sprint.md` dosyalarını günceller.

---

## 🛡️ GİT VE COMMIT İZOLASYON PROTOKOLÜ (HAYALET EKİP KURALI)
AI Olaf Team altyapı dosyaları (`.olaf/`, `AGENTS.md`, `GEMINI.md`, `.cursorrules`, `.clinerules`, `.agent/`, `.agents/`, `.gemini/`, `.idx/`) yalnızca yerel asistanlık ve takım orkestrasyonu içindir:
- **ASLA COMMIT EDİLMEZ:** Hiçbir ajan veya otomasyon, AI Olaf Team altyapı ve kural dosyalarını Git reposuna stage edemez veya commit edemez.
- **YALNIZCA PROJE KODLARI:** Yalnızca projenin gerçek kaynak kodları, konfigürasyonları, testleri ve mimari dosyaları commit edilir.
- Projedeki `.gitignore` ve `.git/info/exclude` kuralları ile `pre-commit` kancası bu izolasyonu daima garanti altında tutar.
"@

[System.IO.File]::WriteAllText((Join-Path $targetDir "GEMINI.md"), $masterRules, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $targetDir "AGENTS.md"), $masterRules, $utf8NoBom)

$idxDir = Join-Path $targetDir ".idx"
New-Item -ItemType Directory -Force -Path $idxDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $idxDir "airules.md"), $masterRules, $utf8NoBom)

$geminiDir = Join-Path $targetDir ".gemini"
New-Item -ItemType Directory -Force -Path $geminiDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $geminiDir "styleguide.md"), $masterRules, $utf8NoBom)

$githubDir = Join-Path $targetDir ".github"
New-Item -ItemType Directory -Force -Path $githubDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $githubDir "copilot-instructions.md"), $masterRules, $utf8NoBom)

[System.IO.File]::WriteAllText((Join-Path $targetDir ".cursorrules"), $masterRules, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $targetDir ".clinerules"), $masterRules, $utf8NoBom)

# 9. VS CODE TASKS ENTEGRASYONU
$vscodeDir = Join-Path $targetDir ".vscode"
New-Item -ItemType Directory -Force -Path $vscodeDir | Out-Null
$tasksJson = @"
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Olaf Team: Projeyi Tara ve Güncelle",
      "type": "shell",
      "command": "olaf-init",
      "problemMatcher": [],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}
"@
$tasksJsonPath = Join-Path $vscodeDir "tasks.json"
if (-not (Test-Path -LiteralPath $tasksJsonPath)) {
    [System.IO.File]::WriteAllText($tasksJsonPath, $tasksJson, $utf8NoBom)
}

# 10. GİT İZOLASYONU VE COMMIT ENGELLEME (GITIGNORE & LOCAL EXCLUDE)
Write-Host "`n$cBlue🛡️  Git İzolasyonu Yapılandırılıyor (Olaf Dosyaları Commit'ten Korunuyor)...$cReset"

$olafIgnoreBlock = @"

# >>> AI OLAF TEAM - LOCAL WORKSPACE & AGENT ISOLATION (DO NOT COMMIT) >>>
.olaf/
.agent/
.agents/
.gemini/
.idx/
AGENTS.md
GEMINI.md
.cursorrules
.clinerules
.github/copilot-instructions.md
.vscode/tasks.json
# <<< AI OLAF TEAM - LOCAL WORKSPACE & AGENT ISOLATION <<<
"@

# A) Proje Kökündeki .gitignore Dosyasına Ekle
$gitignoreFile = Join-Path $targetDir ".gitignore"
try {
    if (Test-Path -LiteralPath $gitignoreFile) {
        $giContent = [System.IO.File]::ReadAllText($gitignoreFile, [System.Text.Encoding]::UTF8)
        if ($giContent -notmatch "AI OLAF TEAM" -and $giContent -notmatch "^\.olaf/?`$") {
            Add-Content -LiteralPath $gitignoreFile -Value $olafIgnoreBlock -Encoding UTF8
            Write-Host "$cGreen✓ .gitignore dosyasına AI Olaf Team izolasyon kuralları eklendi.$cReset"
        } else {
            Write-Host "$cGreen✓ .gitignore içinde Olaf izolasyon kuralları zaten mevcut.$cReset"
        }
    } else {
        [System.IO.File]::WriteAllText($gitignoreFile, $olafIgnoreBlock.TrimStart(), $utf8NoBom)
        Write-Host "$cGreen✓ .gitignore dosyası oluşturuldu ve AI Olaf Team izolasyon kuralları eklendi.$cReset"
    }
} catch {
    Write-Host "$cYellow! .gitignore güncellenirken uyarı: $($_.Exception.Message)$cReset"
}

# B) .git/info/exclude (Yerel ve Görünmez Git Yoksayma)
$gitDir = Join-Path $targetDir ".git"
if (Test-Path -LiteralPath $gitDir) {
    try {
        $gitInfoDir = Join-Path $gitDir "info"
        if (-not (Test-Path -LiteralPath $gitInfoDir)) {
            New-Item -ItemType Directory -Force -Path $gitInfoDir | Out-Null
        }
        $excludeFile = Join-Path $gitInfoDir "exclude"
        $exContent = if (Test-Path -LiteralPath $excludeFile) {
            [System.IO.File]::ReadAllText($excludeFile, [System.Text.Encoding]::UTF8)
        } else {
            ""
        }
        if ($exContent -notmatch "AI OLAF TEAM") {
            Add-Content -LiteralPath $excludeFile -Value $olafIgnoreBlock -Encoding UTF8
            Write-Host "$cGreen✓ .git/info/exclude içine yerel izolasyon kuralları işlendi.$cReset"
        }
    } catch {}

    # C) Önceden Git Staging'e veya Takibe Girmiş Olaf Dosyalarını Güvenle Çıkar (Untrack)
    try {
        if (Get-Command git -ErrorAction SilentlyContinue) {
            $stagedOlaf = git -C "$targetDir" ls-files .olaf AGENTS.md GEMINI.md .cursorrules .clinerules .agent .agents .gemini .idx .github/copilot-instructions.md .vscode/tasks.json 2>$null
            if ($stagedOlaf) {
                git -C "$targetDir" rm --cached -r --quiet .olaf AGENTS.md GEMINI.md .cursorrules .clinerules .agent .agents .gemini .idx .github/copilot-instructions.md .vscode/tasks.json 2>$null
                Write-Host "$cGreen✓ Daha önce git takibine girmiş Olaf dosyaları güvenle un-staged yapıldı.$cReset"
            }
        }
    } catch {}
}

# 11. GİT HOOKS ENTEGRASYONU (PRE-COMMIT GUARD VE POST-COMMIT BEYİN GÜNCELLEYİCİ)
if (Test-Path -LiteralPath $gitDir) {
    try {
        Write-Host "$cBlue🔗 Git Hooks Entegre Ediliyor (Pre-Commit Guard & Post-Commit Sync)...$cReset"
        $hooksDir = Join-Path $gitDir "hooks"
        if (-not (Test-Path -LiteralPath $hooksDir)) {
            New-Item -ItemType Directory -Force -Path $hooksDir | Out-Null
        }

        # 1) PRE-COMMIT HOOK: Olaf dosyalarının kazara commit edilmesini engelleyen kalkan
        $preCommitFile = Join-Path $hooksDir "pre-commit"
        $preCommitGuard = @'
# >>> AI OLAF TEAM PRE-COMMIT GUARD >>>
OLAF_PATTERNS="(\.olaf/|\.agent/|\.agents/|\.gemini/|\.idx/|AGENTS\.md|GEMINI\.md|\.cursorrules|\.clinerules|\.github/copilot-instructions\.md|\.vscode/tasks\.json)"
STAGED_OLAF=$(git diff --cached --name-only 2>/dev/null | grep -E "^$OLAF_PATTERNS" || true)

if [ -n "$STAGED_OLAF" ]; then
    echo "🛡️  [AI Olaf Team] Ekip/hafıza dosyaları commit'ten güvenle ayrıştırılıyor (un-staged)..."
    git reset HEAD -- .olaf .agent .agents .gemini .idx AGENTS.md GEMINI.md .cursorrules .clinerules .github/copilot-instructions.md .vscode/tasks.json 2>/dev/null || true
    echo "✓ [AI Olaf Team] Yalnızca projenin kaynak kodları commit edilecek."
fi
# <<< AI OLAF TEAM PRE-COMMIT GUARD <<<
'@

        if (Test-Path -LiteralPath $preCommitFile) {
            $existingPre = [System.IO.File]::ReadAllText($preCommitFile, [System.Text.Encoding]::UTF8)
            if ($existingPre -notmatch "AI OLAF TEAM PRE-COMMIT GUARD") {
                $newPre = "$existingPre`n`n$preCommitGuard"
                $newPreLf = $newPre.Replace("`r`n", "`n")
                [System.IO.File]::WriteAllText($preCommitFile, $newPreLf, $utf8NoBom)
                Write-Host "$cGreen✓ Mevcut pre-commit hook içine Olaf commit koruması eklendi.$cReset"
            }
        } else {
            $newPre = "#!/usr/bin/env bash`n$preCommitGuard`n"
            $newPreLf = $newPre.Replace("`r`n", "`n")
            [System.IO.File]::WriteAllText($preCommitFile, $newPreLf, $utf8NoBom)
            Write-Host "$cGreen✓ pre-commit koruma kancası oluşturuldu.$cReset"
        }

        # 2) POST-COMMIT HOOK: Brain dosyasındaki son commit bilgisini güncelleyici
        $postCommitFile = Join-Path $hooksDir "post-commit"
        $postCommitSync = @'
# >>> AI OLAF TEAM POST-COMMIT SYNC >>>
if [ -f ".olaf/memory/project-brain.md" ]; then
    LAST_HASH=$(git log -1 --format="%h" 2>/dev/null)
    LAST_MSG=$(git log -1 --format="%s" 2>/dev/null)
    LAST_DATE=$(git log -1 --format="%cd" --date=format:'%Y-%m-%d %H:%M:%S' 2>/dev/null)
    
    sed -e "s/Son Commit ID:.*/Son Commit ID: $LAST_HASH/g" \
        -e "s/Son Commit Mesajı:.*/Son Commit Mesajı: $LAST_MSG/g" \
        -e "s/Son Değişiklik Tarihi:.*/Son Değişiklik Tarihi: $LAST_DATE/g" \
        .olaf/memory/project-brain.md > .olaf/memory/project-brain.tmp 2>/dev/null && \
        mv .olaf/memory/project-brain.tmp .olaf/memory/project-brain.md 2>/dev/null || true
fi
# <<< AI OLAF TEAM POST-COMMIT SYNC <<<
'@

        if (Test-Path -LiteralPath $postCommitFile) {
            $existingPost = [System.IO.File]::ReadAllText($postCommitFile, [System.Text.Encoding]::UTF8)
            if ($existingPost -notmatch "AI OLAF TEAM POST-COMMIT SYNC") {
                $newPost = "$existingPost`n`n$postCommitSync"
                $newPostLf = $newPost.Replace("`r`n", "`n")
                [System.IO.File]::WriteAllText($postCommitFile, $newPostLf, $utf8NoBom)
                Write-Host "$cGreen✓ Mevcut post-commit hook güncellendi.$cReset"
            }
        } else {
            $newPost = "#!/usr/bin/env bash`n$postCommitSync`n"
            $newPostLf = $newPost.Replace("`r`n", "`n")
            [System.IO.File]::WriteAllText($postCommitFile, $newPostLf, $utf8NoBom)
            Write-Host "$cGreen✓ post-commit kancası oluşturuldu.$cReset"
        }
    } catch {
        # Hook yazılamazsa süreci durdurma
    }
}

# 12. BAŞARI RAPORU VE KULLANICI BİLGİLENDİRMESİ
Write-Host "`n$cBold$cGreen=========================================================================="
Write-Host "    🎉 AI OLAF TEAM BAŞARIYLA ENTEGRE EDİLDİ!                            "
Write-Host "==========================================================================$cReset"
Write-Host "📁 Proje Adı       : $cCyan$projectName$cReset"
Write-Host "🏷️  Proje Türü      : $cYellow$projectType$cReset"
Write-Host "👥 Hazır Ajanlar   : $cGreen 15 Uzman Ajan (.olaf/base-agents & learned-skills)$cReset"
Write-Host "🌉 Kurulan Köprüler: $cCyan Antigravity (.agent/workflows), VS Code, Cursor, Copilot$cReset"
Write-Host "🛡️  Git İzolasyonu  : $cGreen Tam Korumalı (Olaf dosyaları commit edilmez, repo temiz kalır)$cReset"

if ($isBrownfield) {
    Write-Host "`n$cBold$cYellow👉 SIRADAKİ ADIM (ÖNEMLİ):$cReset"
    Write-Host "Projenizde mevcut kodlar tespit edildi! Lütfen Antigravity veya VS Code sohbetinde:"
    Write-Host "   $cBold$cCyan/olaf-train$cReset"
    Write-Host "komutunu çalıştırarak 15 kişilik ekibin projeyi öğrenmesini sağlayın.`n"
} else {
    Write-Host "`n$cBold$cGreen👉 SIRADAKİ ADIM:$cReset"
    Write-Host "Sıfırdan proje geliştirme hazır! Antigravity veya VS Code sohbetinde:"
    Write-Host "   $cBold$cCyan/pm [yapmak istediğiniz proje veya özellik]$cReset"
    Write-Host "yazarak ekibi hemen yönetmeye başlayabilirsiniz.`n"
}
