<#
==============================================================================
AI OLAF TEAM - PRE-COMMIT HOOK & LINT ENTEGRASYON TESTİ (demo-hook-test.ps1)
==============================================================================
Bu betik, geçici izole bir Git deposu kurarak:
1. Projenin mevcut pre-commit kontrollerinin (lint/test) Olaf eklense dahi korunduğunu,
2. Lint veya test hata verdiğinde commit işleminin durduğunu,
3. Hata düzeltildiğinde commit'in başarıyla gerçekleştiğini,
4. Olaf yönetim ve hafıza dosyalarının bu süreçte repoya asla sızmadığını
otomatik olarak doğrular ve sonuç raporu sunar.
==============================================================================
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

# ANSI Renkleri
$esc = [char]27
$cReset = "$esc[0m"
$cBold = "$esc[1m"
$cCyan = "$esc[36m"
$cGreen = "$esc[32m"
$cYellow = "$esc[33m"
$cRed = "$esc[31m"

Write-Host "`n$cBold$cCyan==========================================================================$cReset"
Write-Host "$cBold$cCyan    🧪 AI OLAF TEAM - PRE-COMMIT HOOK VE GHOST MODU CANLI DOĞRULAMA$cReset"
Write-Host "$cBold$cCyan==========================================================================$cReset`n"

# 1. AI Olaf Team Merkezi Reposunu Bul
$olafCentral = (Get-Location).Path
$initScript = Join-Path $olafCentral "scripts\olaf-init.ps1"
if (-not (Test-Path -LiteralPath $initScript)) {
    Write-Error "olaf-init.ps1 bulunamadı: $initScript"
}

# 2. Geçici İzole Test Projesi Dizini Hazırla
$demoDir = Join-Path $env:TEMP "olaf-hook-demo-$(Get-Random)"
New-Item -ItemType Directory -Force -Path $demoDir | Out-Null
Set-Location $demoDir

try {
    Write-Host "$cBold[Adım 1/5]$cReset Geçici izole Git projesi oluşturuluyor..."
    git init -q
    git config user.email "test@olaf-team.local"
    git config user.name "Olaf Tester"

    # 3. Projenin MEVCUT (Olaf Öncesi) Pre-Commit Hook'unu Kur
    Write-Host "$cBold[Adım 2/5]$cReset Projenin kendi orijinal LINT kontrolü kancaya ekleniyor..."
    $hooksDir = Join-Path $demoDir ".git\hooks"
    if (-not (Test-Path $hooksDir)) { New-Item -ItemType Directory -Force -Path $hooksDir | Out-Null }
    
    $projectPreCommit = Join-Path $hooksDir "pre-commit"
    $origLintScript = @'
#!/usr/bin/env bash
# >>> PROJENIN MEVCUT LINT/TEST KONTROLU >>>
echo "[Project Hook] ESLint ve Birim Testler calistiriliyor..."
if grep -q "KASITLI_LINT_HATASI" src/*.js 2>/dev/null; then
    echo "❌ [LINT HATA] Kod stil kilavuzuna aykiri desen tespit edildi!"
    echo "Commit iptal ediliyor."
    exit 1
fi
echo "✓ [LINT OK] Kod kontrolleri basariyla gecti."
# <<< PROJENIN MEVCUT LINT/TEST KONTROLU <<<
'@
    [System.IO.File]::WriteAllText($projectPreCommit, ($origLintScript.Replace("`r`n", "`n")), (New-Object System.Text.UTF8Encoding($false)))

    # 4. Olaf Init Çalıştır (Mevcut hook'a entegre olmalı)
    Write-Host "$cBold[Adım 3/5]$cReset 'olaf-init' çalıştırılarak Olaf ekibi bağlanıyor..."
    $env:AI_OLAF_TEAM_DIR = $olafCentral
    & powershell -ExecutionPolicy Bypass -File $initScript | Out-Null

    # Hook kontrolü: Hem orijinal kod hem Olaf guard olmalı
    $hookContent = [System.IO.File]::ReadAllText($projectPreCommit, [System.Text.Encoding]::UTF8)
    $hasOrig = $hookContent -match "PROJENIN MEVCUT LINT/TEST KONTROLU"
    $hasOlaf = $hookContent -match "AI OLAF TEAM PRE-COMMIT GUARD"

    if ($hasOrig -and $hasOlaf) {
        Write-Host "   $cGreen✓ Hook Birleşimi Başarılı:$cReset Orijinal lint kodu silinmedi, Olaf Guard eklendi."
    } else {
        Write-Host "   $cRed❌ Hata: Hook birleşimi başarısız!$cReset"
        exit 1
    }

    # 5. TEST SENARYOSU A: Hatalı Kod + Olaf Dosyası Stage Edildiğinde Commit
    Write-Host "`n$cBold[Adım 4/5 - SENARYO A]$cReset Kasıtlı lint hatası içeren dosya ile commit deneniyor..."
    New-Item -ItemType Directory -Force -Path (Join-Path $demoDir "src") | Out-Null
    Set-Content -Path (Join-Path $demoDir "src\app.js") -Value "const x = 'KASITLI_LINT_HATASI';"
    
    # Hem hatalı kodu hem de kazara stage edilmiş Olaf dosyasını ekle
    git add src/app.js
    git add GEMINI.md -f 2>$null

    $commitFailed = $false
    try {
        $ErrorActionPreference = "Continue"
        $commitOut = git commit -m "feat: hatali commit denemesi" 2>&1
        if ($LASTEXITCODE -ne 0) {
            $commitFailed = $true
        }
    } finally {
        $ErrorActionPreference = "Stop"
    }

    if ($commitFailed) {
        Write-Host "   $cGreen✓ BEKLENEN DAVRANIŞ:$cReset Lint hatası nedeniyle commit DURDURULDU (Engellendi)."
        $headOut = cmd /c "git rev-parse --verify HEAD 2>&1"
        if ($LASTEXITCODE -ne 0) {
            Write-Host "   $cGreen✓ DOĞRULAMA:$cReset Git geçmişinde hiçbir commit oluşmadı (temiz)."
        }
    } else {
        Write-Host "   $cRed❌ BAŞARISIZ:$cReset Lint hatasına rağmen commit atılabildi!"
        exit 1
    }

    # 6. TEST SENARYOSU B: Hata Düzeltildiğinde Commit
    Write-Host "`n$cBold[Adım 5/5 - SENARYO B]$cReset Lint hatası düzeltilip tekrar commit deneniyor..."
    Set-Content -Path (Join-Path $demoDir "src\app.js") -Value "const x = 'TEMIZ_KOD';"
    git add src/app.js
    git add GEMINI.md -f 2>$null  # Kazara tekrar stage edilse dahi

    $commitSuccess = $false
    $ErrorActionPreference = "Continue"
    $commitOut2 = git commit -m "feat: temiz kod ile basarili commit" 2>&1
    if ($LASTEXITCODE -eq 0) {
        $commitSuccess = $true
    }
    $ErrorActionPreference = "Stop"

    if ($commitSuccess) {
        Write-Host "   $cGreen✓ BEKLENEN DAVRANIŞ:$cReset Hata düzeltilince commit BAŞARIYLA tamamlandı."
        
        # Repoya giren dosyaları denetle (GEMINI.md veya .olaf asla girmemeli)
        $committedFiles = git show --pretty="" --name-only HEAD
        Write-Host "   📦 Commit'e dahil edilen dosyalar:"
        foreach ($f in ($committedFiles -split "`r?`n" | Where-Object { $_.Trim() -ne "" })) {
            Write-Host "      - $f"
        }

        $olafLeak = $committedFiles | Select-String "GEMINI|\.olaf"
        if (-not $olafLeak) {
            Write-Host "   $cBold$cGreen✓ GHOST MODU KORUNDU:$cReset Olaf dosyaları repoya sızmadı, yalnızca kaynak kodu commit edildi."
        } else {
            Write-Host "   $cRed❌ SIZINTI TESPİT EDİLDİ:$cReset Olaf dosyaları commit içine girmiş!"
            exit 1
        }
    } else {
        Write-Host "   $cRed❌ BAŞARISIZ:$cReset Düzeltilmiş kod commit edilemedi: $commitOut2$cReset"
        exit 1
    }

    Write-Host "`n$cBold$cGreen==========================================================================$cReset"
    Write-Host "$cBold$cGreen    🎉 TÜM DOĞRULAMA TESTLERİ BAŞARIYLA GEÇTİ! [PASS]$cReset"
    Write-Host "$cBold$cGreen    1. Mevcut lint/test kancası korundu ve hatalı commiti durdurdu.$cReset"
    Write-Host "$cBold$cGreen    2. Hata düzeltilince commit devam etti.$cReset"
    Write-Host "$cBold$cGreen    3. Olaf dosyaları un-staged edilerek repo temiz tutuldu.$cReset"
    Write-Host "$cBold$cGreen==========================================================================$cReset`n"

} finally {
    Set-Location $olafCentral
    Remove-Item -Recurse -Force $demoDir -ErrorAction SilentlyContinue
}
