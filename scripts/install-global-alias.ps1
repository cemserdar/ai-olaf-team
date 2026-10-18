<#
==============================================================================
AI OLAF TEAM - WINDOWS GLOBAL KOMUT VE ALIAS KURULUM BETİĞİ (POWERSHELL)
==============================================================================
Bu betik, Windows üzerinde 'olaf-init' komutunu hem PowerShell Profiline
hem de sistem PATH ortam değişkenine ekleyerek herhangi bir terminalden
(PowerShell, Windows Terminal veya CMD) doğrudan çağrılabilmesini sağlar.
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

Write-Host "$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    🔗 AI OLAF TEAM - WINDOWS GLOBAL KURULUM SİHİRBAZI                  $cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset"

# 1. REPO DİZİNİNİ TESPİT ET
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = Split-Path -Parent $scriptDir

Write-Host "$cGreen✓ AI Olaf Team Repo Yolu:$cReset $repoDir"

# 2. ORTAM DEĞİŞKENİNİ (AI_OLAF_TEAM_DIR) KALICI OLARAK TANIMLA
[Environment]::SetEnvironmentVariable("AI_OLAF_TEAM_DIR", $repoDir, "User")
$env:AI_OLAF_TEAM_DIR = $repoDir
Write-Host "$cGreen✓ Kullanıcı Ortam Değişkeni Tanımlandı:$cReset AI_OLAF_TEAM_DIR = $repoDir"

# 3. KULLANICI İÇİN ÇALIŞTIRILABİLİR BIN DİZİNİ OLUŞTUR (~/.local/bin)
$localBin = Join-Path $HOME ".local\bin"
if (-not (Test-Path $localBin)) {
    New-Item -ItemType Directory -Force -Path $localBin | Out-Null
}

# olaf-init.cmd (CMD ve Batch için)
$cmdWrapper = @"
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "$repoDir\scripts\olaf-init.ps1" %*
"@
[System.IO.File]::WriteAllText((Join-Path $localBin "olaf-init.cmd"), $cmdWrapper, [System.Text.Encoding]::UTF8)

# olaf-init.ps1 (PowerShell doğrudan çağrıları için)
$psWrapper = @"
& "$repoDir\scripts\olaf-init.ps1" `@args
"@
[System.IO.File]::WriteAllText((Join-Path $localBin "olaf-init.ps1"), $psWrapper, [System.Text.Encoding]::UTF8)

Write-Host "$cGreen✓ Çalıştırılabilir Başlatıcılar Oluşturuldu:$cReset $localBin\olaf-init.cmd / .ps1"

# 4. PATH ORTAM DEĞİŞKENİNİ GÜNCELLE
$currentUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentUserPath -notlike "*$localBin*") {
    $newUserPath = if ([string]::IsNullOrWhiteSpace($currentUserPath)) { $localBin } else { "$currentUserPath;$localBin" }
    [Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
    $env:PATH = "$localBin;$env:PATH"
    Write-Host "$cGreen✓ PATH Ortam Değişkeni Güncellendi:$cReset $localBin eklendi."
} else {
    Write-Host "$cYellow✓ PATH içinde $localBin zaten kayıtlı.$cReset"
}

# 5. POWERSHELL PROFİLİNE ($PROFILE) DOĞRUDAN FONKSİYON EKLE
$profileSnippet = @"

# >>> AI OLAF TEAM GLOBAL INTEGRATION >>>
`$env:AI_OLAF_TEAM_DIR = "$repoDir"
function olaf-init { & "`$env:AI_OLAF_TEAM_DIR\scripts\olaf-init.ps1" `@args }
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
        Write-Host "$cYellow✓ PowerShell Profilinde ($PROFILE) zaten tanımlı.$cReset"
    } else {
        Add-Content -Path $PROFILE -Value $profileSnippet
        Write-Host "$cGreen✓ PowerShell Profiline ($PROFILE) olaf-init eklendi.$cReset"
    }
} catch {
    Write-Host "$cYellow⚠️ Not: Profil dosyası otomatik güncellenemedi, ancak PATH üzerinden çalıştırma hazır.$cReset"
}

Write-Host "`n$cBold$cGreen🎉 TEBRİKLER! Windows Kurulumu Başarıyla Tamamlandı.$cReset"
Write-Host "`nDeğişikliklerin geçerli olması için PowerShell veya CMD terminalinizi kapatıp yeniden açın."
Write-Host "Artık dilediğiniz herhangi bir proje klasörüne gidip sadece:"
Write-Host "   $cBold$cGreen olaf-init $cReset"
Write-Host "yazarak 15 kişilik otonom ekibi projenize anında dahil edebilirsiniz!`n"
