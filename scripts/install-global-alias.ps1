<#
==============================================================================
AI OLAF TEAM - WINDOWS GLOBAL KOMUT VE ALIAS KURULUM BETİĞİ (POWERSHELL)
==============================================================================
Bu betik, Windows üzerinde 'olaf-init' komutunu PowerShell Profiline,
sistem PATH ortam değişkenine ve CMD/Git Bash çalıştırıcılarına ekleyerek
herhangi bir terminalden (PowerShell, Windows Terminal, CMD, Git Bash, VS Code)
doğrudan çağrılabilmesini sağlar.
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

# ANSI Renk Kodları veya Düz Metin Uyumluluğu
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

# Simge Tanımlamaları ([char] kullanılarak UTF-8/ANSI uyumluluk güvencesi)
$symCheck = if ($supportsAnsi) { "$([char]0x2713) " } else { "[OK] " }
$symWarn  = "[!] "
$symInfo  = "[*] "
$symTrophy = "[*] "

Write-Host "$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    $symInfo AI OLAF TEAM - WINDOWS GLOBAL KURULUM SİHİRBAZI                  $cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset"

# 1. REPO DİZİNİNİ TESPİT ET
$scriptDir = $PSScriptRoot
if (-not $scriptDir) {
    if ($MyInvocation.MyCommand.Path) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    } elseif ($MyInvocation.MyCommand.Definition) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    } else {
        $scriptDir = (Get-Location).Path
    }
}
$repoDir = Split-Path -Parent $scriptDir

Write-Host "$cGreen$symCheck AI Olaf Team Repo Yolu:$cReset $repoDir"

# 2. POWERSHELL EXECUTION POLICY (BETİK ÇALIŞTIRMA İZNİ) KONTROLÜ
Write-Host "`n$cBlue$symInfo PowerShell Betik Çalıştırma İzinleri (ExecutionPolicy) Denetleniyor...$cReset"
try {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "Undefined") {
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        Write-Host "$cGreen$symCheck PowerShell ExecutionPolicy CurrentUser için 'RemoteSigned' yapıldı.$cReset"
    } else {
        Write-Host "$cGreen$symCheck PowerShell ExecutionPolicy zaten uygun ($currentPolicy).$cReset"
    }
} catch {
    Write-Host "$cYellow$symWarn ExecutionPolicy güncellenemedi (Grup İlkesi kısıtlaması olabilir). Bypass wrapper'ları kullanılacak.$cReset"
}

# 3. ORTAM DEĞİŞKENİNİ (AI_OLAF_TEAM_DIR) KALICI OLARAK TANIMLA
[Environment]::SetEnvironmentVariable("AI_OLAF_TEAM_DIR", $repoDir, "User")
$env:AI_OLAF_TEAM_DIR = $repoDir
Write-Host "$cGreen$symCheck Kullanıcı Ortam Değişkeni Tanımlandı:$cReset AI_OLAF_TEAM_DIR = $repoDir"

# 4. KULLANICI İÇİN ÇALIŞTIRILABİLİR BIN DİZİNİ OLUŞTUR (~/.local/bin)
$localBin = Join-Path $HOME ".local\bin"
if (-not (Test-Path $localBin)) {
    New-Item -ItemType Directory -Force -Path $localBin | Out-Null
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# olaf-init.cmd (CMD ve Windows Terminal için)
$cmdWrapper = @"
@echo off
setlocal
chcp 65001 >nul
set "OLAF_REPO=$repoDir"
where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%OLAF_REPO%\scripts\olaf-init.ps1" %*
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%OLAF_REPO%\scripts\olaf-init.ps1" %*
)
endlocal
"@
[System.IO.File]::WriteAllText((Join-Path $localBin "olaf-init.cmd"), $cmdWrapper, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $localBin "olaf-init.bat"), $cmdWrapper, $utf8NoBom)

# Git Bash / MSYS terminali için olaf-init wrapper'ı
$repoDirUnix = $repoDir.Replace('\', '/')
$bashWrapper = @"
#!/usr/bin/env bash
export AI_OLAF_TEAM_DIR="$repoDirUnix"
if command -v pwsh >/dev/null 2>&1; then
    exec pwsh -NoProfile -ExecutionPolicy Bypass -File "$repoDirUnix/scripts/olaf-init.ps1" "`$@"
elif command -v powershell.exe >/dev/null 2>&1; then
    exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$repoDirUnix/scripts/olaf-init.ps1" "`$@"
elif [ -f "$repoDirUnix/scripts/olaf-init.sh" ]; then
    exec bash "$repoDirUnix/scripts/olaf-init.sh" "`$@"
fi
"@
$bashWrapperLf = $bashWrapper.Replace("`r`n", "`n")
[System.IO.File]::WriteAllText((Join-Path $localBin "olaf-init"), $bashWrapperLf, $utf8NoBom)

# ÖNEMLİ: PowerShell'in PATH içindeki .ps1 dosyasını Bypass olmadan doğrudan çalıştırmasını engellemek için
# .local\bin içindeki eski olaf-init.ps1 varsa kaldırılır (PowerShell olaf-init.cmd veya Profil fonksiyonunu kullanmalıdır)
$oldPsWrapper = Join-Path $localBin "olaf-init.ps1"
if (Test-Path $oldPsWrapper) {
    Remove-Item -Path $oldPsWrapper -Force -ErrorAction SilentlyContinue
}

Write-Host "$cGreen$symCheck Çalıştırılabilir Başlatıcılar Oluşturuldu:$cReset"
Write-Host "   - $localBin\olaf-init.cmd (CMD / Terminal)"
Write-Host "   - $localBin\olaf-init.bat (Batch)"
Write-Host "   - $localBin\olaf-init (Git Bash / MSYS)"

# 5. PATH ORTAM DEĞİŞKENİNİ GÜNCELLE
$currentUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentUserPath -notlike "*$localBin*") {
    $newUserPath = if ([string]::IsNullOrWhiteSpace($currentUserPath)) { $localBin } else { "$currentUserPath;$localBin" }
    [Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
    Write-Host "$cGreen$symCheck PATH Ortam Değişkeni Güncellendi:$cReset $localBin eklendi."
} else {
    Write-Host "$cYellow$symCheck PATH içinde $localBin zaten kayıtlı.$cReset"
}
# Mevcut çalışan session'ın PATH değişkenine de ekle
if ($env:PATH -notlike "*$localBin*") {
    $env:PATH = "$localBin;$env:PATH"
}

# 6. POWERSHELL PROFİLİNE ($PROFILE) DOĞRUDAN FONKSİYON EKLE
$profileSnippet = @"

# >>> AI OLAF TEAM GLOBAL INTEGRATION >>>
`$env:AI_OLAF_TEAM_DIR = "$repoDir"
function olaf-init {
    `$olafScript = Join-Path "`$env:AI_OLAF_TEAM_DIR" "scripts\olaf-init.ps1"
    if (Get-Command pwsh -ErrorAction SilentlyContinue) {
        & pwsh -NoProfile -ExecutionPolicy Bypass -File `$olafScript `@args
    } else {
        & powershell -NoProfile -ExecutionPolicy Bypass -File `$olafScript `@args
    }
}
# <<< AI OLAF TEAM GLOBAL INTEGRATION <<<
"@

try {
    if (-not (Test-Path $PROFILE)) {
        $profileDir = Split-Path -Parent $PROFILE
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
        }
        New-Item -ItemType File -Force -Path $PROFILE | Out-Null
    }

    $existingProfile = Get-Content -Path $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($existingProfile -match "AI OLAF TEAM GLOBAL INTEGRATION") {
        # Eski profil tanımını güncel ve bypass korumalı versiyonla yenile
        $cleanedProfile = [regex]::Replace($existingProfile, "(?s)# >>> AI OLAF TEAM GLOBAL INTEGRATION >>>.*?# <<< AI OLAF TEAM GLOBAL INTEGRATION <<<", "").Trim()
        $updatedProfile = "$cleanedProfile`r`n$profileSnippet"
        [System.IO.File]::WriteAllText($PROFILE, $updatedProfile, [System.Text.Encoding]::UTF8)
        Write-Host "$cGreen$symCheck PowerShell Profilindeki ($PROFILE) olaf-init fonksiyonu güncellendi.$cReset"
    } else {
        Add-Content -Path $PROFILE -Value $profileSnippet
        Write-Host "$cGreen$symCheck PowerShell Profiline ($PROFILE) olaf-init eklendi.$cReset"
    }
} catch {
    Write-Host "$cYellow$symWarn Not: Profil dosyası otomatik güncellenemedi, ancak PATH (.cmd) üzerinden çalıştırma hazır.$cReset"
}

Write-Host "`n$cBold$cGreen$symTrophy TEBRİKLER! Windows Kurulumu Başarıyla Tamamlandı.$cReset"
Write-Host "`nDeğişikliklerin geçerli olması için PowerShell, CMD veya VS Code terminalinizi kapatıp yeniden açın."
Write-Host "Artık dilediğiniz herhangi bir proje klasörüne gidip sadece:"
Write-Host "   $cBold$cGreen olaf-init $cReset"
Write-Host "yazarak 15 kişilik otonom ekibi projenize anında dahil edebilirsiniz!`n"
