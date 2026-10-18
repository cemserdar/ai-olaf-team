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

# ANSI Renk Kodları
$esc = [char]27
$cReset = "$esc[0m"
$cBold = "$esc[1m"
$cCyan = "$esc[36m"
$cGreen = "$esc[32m"
$cYellow = "$esc[33m"
$cBlue = "$esc[34m"
$cMagenta = "$esc[35m"
$cRed = "$esc[31m"

Write-Host "$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    🚀 AI OLAF TEAM - OTONOM YAZILIM TAKIMI ENTEGRASYON MOTORU (WINDOWS)$cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset"

# 1. AI OLAF TEAM MERKEZİ REPO DİZİNİNİ TESPİT ET
$olafCentralDir = $null

if ($env:AI_OLAF_TEAM_DIR -and (Test-Path (Join-Path $env:AI_OLAF_TEAM_DIR "base-agents"))) {
    $olafCentralDir = $env:AI_OLAF_TEAM_DIR
} elseif (Test-Path "$HOME\ai-olaf-team\base-agents") {
    $olafCentralDir = "$HOME\ai-olaf-team"
} else {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $parentDir = Split-Path -Parent $scriptDir
    if (Test-Path (Join-Path $parentDir "base-agents")) {
        $olafCentralDir = $parentDir
    }
}

if (-not $olafCentralDir -or -not (Test-Path (Join-Path $olafCentralDir "base-agents"))) {
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
Get-ChildItem -Path (Join-Path $olafCentralDir "base-agents\*.md") | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $baseAgentsDir -Force
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

if (Test-Path $templateSkillPath) {
    $templateSkillContent = [System.IO.File]::ReadAllText($templateSkillPath, [System.Text.Encoding]::UTF8)
    foreach ($agent in $agentsList) {
        $skillFile = Join-Path $learnedSkillsDir "$($agent.Key)-skills.md"
        if (-not (Test-Path $skillFile)) {
            $content = $templateSkillContent.Replace("{{AGENT_NAME}}", "$($agent.Key.ToUpper()) AGENT")
            $content = $content.Replace("{{AGENT_ROLE}}", $agent.Role)
            $content = $content.Replace("{{AGENT_TAG}}", $agent.Tag)
            $content = $content.Replace("{{LAST_UPDATED}}", $currentDate)
            $content = $content.Replace("{{TRAINING_STATUS}}", "EĞİTİM BEKLİYOR")
            [System.IO.File]::WriteAllText($skillFile, $content, [System.Text.Encoding]::UTF8)
        }
    }
}

# 4. ACTIVE SPRINT BAŞLAT
$activeSprintFile = Join-Path $memoryDir "active-sprint.md"
$templateSprintPath = Join-Path $olafCentralDir "templates\active-sprint-template.md"

if ((-not (Test-Path $activeSprintFile)) -and (Test-Path $templateSprintPath)) {
    $sprintContent = [System.IO.File]::ReadAllText($templateSprintPath, [System.Text.Encoding]::UTF8)
    $sprintContent = $sprintContent.Replace("{{SPRINT_TITLE}}", "Sprint 01 - Proje Kurulumu ve Başlangıç")
    $sprintContent = $sprintContent.Replace("{{SPRINT_START_DATE}}", $currentDate)
    $sprintContent = $sprintContent.Replace("{{SPRINT_GOAL}}", "Projenin analizi, mimari temelleri ve ilk sürüm hedefleri")
    [System.IO.File]::WriteAllText($activeSprintFile, $sprintContent, [System.Text.Encoding]::UTF8)
}

# 5. PROJE TÜRÜNÜ TESPİT ET (BROWNFIELD / GREENFIELD)
Write-Host "`n$cBlue🔍 Proje Röntgeni Çekiliyor ve Kod Taraması Yapılıyor...$cReset"

$sourceExtensions = @("*.cs", "*.java", "*.ts", "*.tsx", "*.js", "*.py", "*.go", "*.rs", "*.php", "*.cpp", "package.json", "pom.xml", "*.csproj", "*.sln")
$excludeDirs = @(".olaf", ".git", "node_modules", "bin", "obj", ".vs", "dist", "build")

$allFiles = Get-ChildItem -Path $targetDir -Recurse -File -Depth 4 -ErrorAction SilentlyContinue
$srcFiles = @()
if ($allFiles) {
    foreach ($file in $allFiles) {
        $rel = $file.FullName.Substring($targetDir.Length)
        $isExcluded = $false
        foreach ($ex in $excludeDirs) {
            if ($rel -match "[\\/]$([regex]::Escape($ex))([\\/]|$)") {
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

$srcCount = $srcFiles.Count
$isBrownfield = $srcCount -gt 0

# 6. RÖNTGEN ANALİZİ VE PROJECT BRAIN DOLDURMA
$detectedStack = ""
$trainingFlagFile = Join-Path $memoryDir "TRAINING_REQUIRED.flag"

if ($isBrownfield) {
    $projectType = "BROWNFIELD (Mevcut Kod Tabanı)"
    $trainingStatus = "EĞİTİM GEREKLİ (/olaf-train çalıştırılmalı)"
    Write-Host "$cYellow⚡ Proje Türü:$cReset $projectType ($srcCount kaynak dosya/paket tespit edildi)"
    
    [System.IO.File]::WriteAllText($trainingFlagFile, "Bu projede mevcut kaynak kodlar tespit edildi. Lütfen /olaf-train komutunu çalıştırarak 15 ajanı eğitin.`n", [System.Text.Encoding]::UTF8)
    
    Write-Host "$cBlue📋 Paket ve Teknoloji Analizi Yapılıyor...$cReset"
    
    # .NET / C#
    $csprojFiles = Get-ChildItem -Path $targetDir -Filter "*.csproj" -Recurse -Depth 3 -ErrorAction SilentlyContinue | Select-Object -First 5
    $slnFiles = Get-ChildItem -Path $targetDir -Filter "*.sln" -Depth 2 -ErrorAction SilentlyContinue
    if ($csprojFiles -or $slnFiles) {
        $detectedStack += "- Backend: .NET / C# tespit edildi.`n"
        foreach ($csproj in $csprojFiles) {
            $relPath = $csproj.FullName.Substring($targetDir.Length).TrimStart('\', '/')
            $detectedStack += "  * Proje: $relPath`n"
        }
    }
    
    # Node / Web / Mobil
    $pkgJsonPath = Join-Path $targetDir "package.json"
    if (Test-Path $pkgJsonPath) {
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
    
    # Java
    if ((Test-Path (Join-Path $targetDir "pom.xml")) -or (Test-Path (Join-Path $targetDir "build.gradle"))) {
        $detectedStack += "- Java Ekosistemi tespit edildi (Maven/Gradle).`n"
    }
    
    # Python
    if ((Test-Path (Join-Path $targetDir "requirements.txt")) -or (Test-Path (Join-Path $targetDir "pyproject.toml"))) {
        $detectedStack += "- Python Ekosistemi tespit edildi.`n"
    }
    
    # Docker
    if ((Test-Path (Join-Path $targetDir "Dockerfile")) -or (Test-Path (Join-Path $targetDir "docker-compose.yml"))) {
        $detectedStack += "- DevOps: Docker / Docker Compose mevcut.`n"
    }
    
    # GitHub Actions
    if (Test-Path (Join-Path $targetDir ".github\workflows")) {
        $detectedStack += "- CI/CD: GitHub Actions iş akışları mevcut.`n"
    }
    
    # Klasör Özeti
    $treeItems = Get-ChildItem -Path $targetDir -Depth 1 -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notmatch "^\." -and $_.Name -notin @("node_modules", "bin", "obj", ".vs", "dist", "build")
    } | Select-Object -First 35
    $treeSummary = ($treeItems | ForEach-Object { $_.FullName.Substring($targetDir.Length).TrimStart('\', '/') }) -join "`n"

} else {
    $projectType = "GREENFIELD (Sıfırdan Proje)"
    $trainingStatus = "HAZIR (Sıfırdan Mimari Başlatılabilir)"
    Write-Host "$cGreen🌱 Proje Türü:$cReset $projectType (Boş proje dizini)"
    if (Test-Path $trainingFlagFile) { Remove-Item -Path $trainingFlagFile -Force }
    $detectedStack = "Henüz kod eklenmedi. Sıfırdan mimari kurgusu için @pm hazır bekliyor.`n"
    $treeSummary = "."
}

# project-brain.md dosyasını şablondan doldur
$templateBrainPath = Join-Path $olafCentralDir "templates\project-brain-template.md"
$brainFile = Join-Path $memoryDir "project-brain.md"

if (Test-Path $templateBrainPath) {
    $brainContent = [System.IO.File]::ReadAllText($templateBrainPath, [System.Text.Encoding]::UTF8)
    $brainContent = $brainContent.Replace("{{PROJECT_NAME}}", $projectName)
    $brainContent = $brainContent.Replace("{{PROJECT_TYPE}}", $projectType)
    $brainContent = $brainContent.Replace("{{CREATED_AT}}", $currentDate)
    $brainContent = $brainContent.Replace("{{LAST_UPDATED}}", $currentDate)
    $brainContent = $brainContent.Replace("{{TRAINING_STATUS}}", $trainingStatus)
    $brainContent = $brainContent.Replace("{{PROJECT_GOAL}}", "$projectName projesinin hedefleri ve isterleri")
    $brainContent = $brainContent.Replace("{{TARGET_AUDIENCE}}", "Kullanıcılar ve Sistem İstemcileri")

    $brainContent += @"

### 🔎 OLAF-INIT İLK RÖNTGEN BULGULARI:
$detectedStack
### 📁 TESPİT EDİLEN KLASÖR AĞACI:
```text
$treeSummary
```
"@
    [System.IO.File]::WriteAllText($brainFile, $brainContent, [System.Text.Encoding]::UTF8)
}

# 7. ANTIGRAVITY VE VS CODE WORKFLOW KÖPRÜLERİNİ KUR
Write-Host "`n$cBlue🌉 Antigravity & IDE Slash Workflows (.agent/workflows) Kuruluyor...$cReset"
$agentWorkflowsDir = Join-Path $targetDir ".agent\workflows"
New-Item -ItemType Directory -Force -Path $agentWorkflowsDir | Out-Null

$workflowsToCopy = @("olaf-train.md", "pm.md", "sync-skills.md", "review-all.md")
foreach ($wf in $workflowsToCopy) {
    $srcWf = Join-Path $olafCentralDir "workflows\$wf"
    if (Test-Path $srcWf) {
        Copy-Item -Path $srcWf -Destination (Join-Path $agentWorkflowsDir $wf) -Force
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
"@

[System.IO.File]::WriteAllText((Join-Path $targetDir "GEMINI.md"), $masterRules, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText((Join-Path $targetDir "AGENTS.md"), $masterRules, [System.Text.Encoding]::UTF8)

$idxDir = Join-Path $targetDir ".idx"
New-Item -ItemType Directory -Force -Path $idxDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $idxDir "airules.md"), $masterRules, [System.Text.Encoding]::UTF8)

$geminiDir = Join-Path $targetDir ".gemini"
New-Item -ItemType Directory -Force -Path $geminiDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $geminiDir "styleguide.md"), $masterRules, [System.Text.Encoding]::UTF8)

$githubDir = Join-Path $targetDir ".github"
New-Item -ItemType Directory -Force -Path $githubDir | Out-Null
[System.IO.File]::WriteAllText((Join-Path $githubDir "copilot-instructions.md"), $masterRules, [System.Text.Encoding]::UTF8)

[System.IO.File]::WriteAllText((Join-Path $targetDir ".cursorrules"), $masterRules, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText((Join-Path $targetDir ".clinerules"), $masterRules, [System.Text.Encoding]::UTF8)

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
[System.IO.File]::WriteAllText((Join-Path $vscodeDir "tasks.json"), $tasksJson, [System.Text.Encoding]::UTF8)

# 10. GİT POST-COMMIT HOOK ENTEGRASYONU
$gitDir = Join-Path $targetDir ".git"
if (Test-Path $gitDir) {
    Write-Host "$cBlue🔗 Git Post-Commit Hook Entegre Ediliyor...$cReset"
    $hooksDir = Join-Path $gitDir "hooks"
    New-Item -ItemType Directory -Force -Path $hooksDir | Out-Null
    
    $hookContent = @"
#!/usr/bin/env bash
# AI Olaf Team Git Post-Commit Güncelleyici
if [ -f ".olaf/memory/project-brain.md" ]; then
    LAST_HASH=`$(git log -1 --format="%h" 2>/dev/null)
    LAST_MSG=`$(git log -1 --format="%s" 2>/dev/null)
    LAST_DATE=`$(git log -1 --format="%cd" --date=format:'%Y-%m-%d %H:%M:%S' 2>/dev/null)
    
    sed -e "s/Son Commit ID:.*/Son Commit ID: `$LAST_HASH/g" \
        -e "s/Son Commit Mesajı:.*/Son Commit Mesajı: `$LAST_MSG/g" \
        -e "s/Son Değişiklik Tarihi:.*/Son Değişiklik Tarihi: `$LAST_DATE/g" \
        .olaf/memory/project-brain.md > .olaf/memory/project-brain.tmp 2>/dev/null && \
        mv .olaf/memory/project-brain.tmp .olaf/memory/project-brain.md 2>/dev/null || true
fi
"@
    [System.IO.File]::WriteAllText((Join-Path $hooksDir "post-commit"), $hookContent, [System.Text.Encoding]::UTF8)
}

# 11. BAŞARI RAPORU VE KULLANICI BİLGİLENDİRMESİ
Write-Host "`n$cBold$cGreen=========================================================================="
Write-Host "    🎉 AI OLAF TEAM BAŞARIYLA ENTEGRE EDİLDİ!                            "
Write-Host "==========================================================================$cReset"
Write-Host "📁 Proje Adı       : $cCyan$projectName$cReset"
Write-Host "🏷️  Proje Türü      : $cYellow$projectType$cReset"
Write-Host "👥 Hazır Ajanlar   : $cGreen 15 Uzman Ajan (.olaf/base-agents & learned-skills)$cReset"
Write-Host "🌉 Kurulan Köprüler: $cCyan Antigravity (.agent/workflows), VS Code, Cursor, Copilot$cReset"

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
