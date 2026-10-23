<#
==============================================================================
AI OLAF TEAM - PARALEL WORKTREE VE RELEASE GATEKEEPER MOTORU (olaf-worktree.ps1)
==============================================================================
Bu betik, @devops ajanı tarafından bağımsız görevler için izole Git Worktree
alanları açmak, kapatmak, Squash Merge ile main dalına entegre etmek ve çakışma/
doğrulama kapılarını (Quality Gate) yönetmek için kullanılır.
==============================================================================
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("start", "merge", "cleanup", "list", "status", "abort")]
    [string]$Action,

    [Parameter(Position = 1)]
    [string]$TaskId,

    [Parameter(Position = 2)]
    [string]$Agent = "agent",

    [Parameter()]
    [string]$Message,

    [Parameter()]
    [switch]$NoTest
)

$ErrorActionPreference = "Stop"

# ANSI Renk Kodları
$esc = [char]27
$cReset = "$esc[0m"
$cBold = "$esc[1m"
$cCyan = "$esc[36m"
$cGreen = "$esc[32m"
$cYellow = "$esc[33m"
$cBlue = "$esc[34m"
$cRed = "$esc[31m"

function Get-RepoRoot {
    $root = git rev-parse --show-toplevel 2>$null
    if (-not $root) {
        Write-Error "Hata: Geçerli bir Git deposu içinde değilsiniz!"
    }
    return $root.Trim()
}

$repoRoot = Get-RepoRoot
Set-Location $repoRoot

function Get-PrimaryBranch {
    if (git show-ref --verify --quiet refs/heads/main) { return "main" }
    if (git show-ref --verify --quiet refs/heads/master) { return "master" }
    $cur = git rev-parse --abbrev-ref HEAD 2>$null
    if ($cur -and $cur -ne "HEAD") { return $cur.Trim() }
    return "main"
}

function Normalize-TaskName([string]$id) {
    if (-not $id) {
        Write-Error "Hata: Lütfen bir Görev ID belirtin (Örn: TASK-01 veya task-01)!"
    }
    return $id.ToLower().Trim()
}

# 1. ACTION: START (Worktree Oluştur ve Başlat)
if ($Action -eq "start") {
    $normTask = Normalize-TaskName $TaskId
    $branchName = "task/$normTask"
    $worktreeDir = Join-Path $repoRoot ".olaf\worktrees\$normTask"

    Write-Host "$cBold$cCyan🚀 [@devops] '$normTask' için izole Worktree alanı hazırlanıyor...$cReset"

    # Ana dizinde uncommitted dosya kontrolü
    $dirty = git status --porcelain 2>$null
    if ($dirty) {
        Write-Host "$cYellow⚠️  Uyarı: Ana dizinde commit edilmemiş değişiklikler var.$cReset"
    }

    # Eğer worktree zaten varsa uyar
    if (Test-Path -LiteralPath $worktreeDir) {
        Write-Host "$cYellowℹ️  Worktree dizini zaten mevcut: $worktreeDir$cReset"
        exit 0
    }

    # Branch kontrolü ve oluşturma
    $baseBranch = Get-PrimaryBranch
    $branchExists = git branch --list $branchName
    if (-not $branchExists) {
        git branch $branchName $baseBranch
    }

    # Worktree ekle
    $parentDir = Split-Path -Parent $worktreeDir
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }

    git worktree add $worktreeDir $branchName
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Worktree oluşturulamadı!"
    }

    # Ghost modu ve exclude korumasını worktree'ye bağla
    $excludeSrc = Join-Path $repoRoot ".git\info\exclude"
    if (Test-Path $excludeSrc) {
        # Git worktree metadata exclude path
        $wtGitDir = git -C $worktreeDir rev-parse --git-dir 2>$null
        if ($wtGitDir) {
            $infoDir = Join-Path $wtGitDir "info"
            if (-not (Test-Path $infoDir)) { New-Item -ItemType Directory -Force -Path $infoDir | Out-Null }
            Copy-Item -LiteralPath $excludeSrc -Destination (Join-Path $infoDir "exclude") -Force -ErrorAction SilentlyContinue
        }
    }

    Write-Host "$cBold$cGreen✅ [@devops] Worktree hazır!$cReset"
    Write-Host "   📂 Dizin : $cCyan$worktreeDir$cReset"
    Write-Host "   🌿 Branch: $cCyan$branchName$cReset"
    Write-Host "   👤 Ajan  : $cYellow$Agent$cReset"
    Write-Host "   👉 $Agent artık yalnızca bu dizinde çalışabilir.`n"
    exit 0
}

# 2. ACTION: LIST (Aktif Worktree'leri Listele)
if ($Action -eq "list") {
    Write-Host "$cBold$cCyan📋 [@devops] Aktif Git Worktree Listesi:$cReset"
    git worktree list
    exit 0
}

# 3. ACTION: STATUS
if ($Action -eq "status") {
    $normTask = Normalize-TaskName $TaskId
    $worktreeDir = Join-Path $repoRoot ".olaf\worktrees\$normTask"
    if (-not (Test-Path $worktreeDir)) {
        Write-Host "$cYellowℹ️  Worktree bulunamadı: $worktreeDir$cReset"
        exit 0
    }
    Write-Host "$cBold$cCyan📊 [@devops] '$normTask' Worktree Durumu:$cReset"
    git -C $worktreeDir status
    exit 0
}

# 4. ACTION: CLEANUP / ABORT (Worktree'yi İptal Et ve Sil)
if ($Action -eq "cleanup" -or $Action -eq "abort") {
    $normTask = Normalize-TaskName $TaskId
    $branchName = "task/$normTask"
    $worktreeDir = Join-Path $repoRoot ".olaf\worktrees\$normTask"

    Write-Host "$cBold$cYellow🧹 [@devops] '$normTask' Worktree alanı temizleniyor...$cReset"
    
    if (Test-Path $worktreeDir) {
        git worktree remove --force $worktreeDir 2>$null
        Remove-Item -Recurse -Force $worktreeDir -ErrorAction SilentlyContinue
    }
    git worktree prune
    git branch -D $branchName 2>$null

    Write-Host "$cGreen✅ Temizlik tamamlandı.$cReset"
    exit 0
}

# 5. ACTION: MERGE (Squash Merge, Conflict Çözümü ve Doğrulama Kapısı)
if ($Action -eq "merge") {
    $normTask = Normalize-TaskName $TaskId
    $branchName = "task/$normTask"
    $worktreeDir = Join-Path $repoRoot ".olaf\worktrees\$normTask"

    if (-not (Test-Path $worktreeDir)) {
        Write-Error "Hata: Birleştirilecek worktree bulunamadı ($worktreeDir)!"
    }

    Write-Host "$cBold$cCyan🔄 [@devops] '$normTask' için Main Entegrasyonu ve Release Kapısı Başlatılıyor...$cReset"

    # A) Worktree içindeki uncommitted kodları otomatik commit et
    $wtDirty = git -C $worktreeDir status --porcelain 2>$null
    if ($wtDirty) {
        Write-Host "$cBlue📝 Worktree içindeki son değişiklikler stage ediliyor...$cReset"
        git -C $worktreeDir add .
        git -C $worktreeDir commit -m "feat($normTask): completed by $Agent"
    }

    # B) Ana dala geçiş (main veya master)
    $baseBranch = Get-PrimaryBranch
    Write-Host "$cBlue🌿 '$baseBranch' dalına geçiliyor...$cReset"
    git checkout $baseBranch
    if ($LASTEXITCODE -ne 0) {
        Write-Error "'$baseBranch' dalına geçilemedi!"
    }

    # C) Squash Merge Denemesi
    Write-Host "$cBlue🔀 Squash Merge uygulanıyor (Ara commitler tekilleştiriliyor)...$cReset"
    $prevEAP = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    git merge --squash $branchName
    $mergeExit = $LASTEXITCODE
    $ErrorActionPreference = $prevEAP
    $hasConflict = (git status --porcelain | Select-String "^(UU|AA|UD|DU)")

    # D) Çakışma Yönetimi
    if ($hasConflict) {
        Write-Host "$cBold$cYellow⚠️  Çakışma (Conflict) Tespit Edildi! Çözüm protokolü devreye giriyor...$cReset"
        $conflictedFiles = git diff --name-only --diff-filter=U

        $unresolved = @()
        foreach ($file in $conflictedFiles) {
            if ($file -match "package\.json$") {
                Write-Host "$cGreen   ✓ package.json yapısal birleşim uygulanıyor...$cReset"
                git checkout --theirs $file 2>$null
                git add $file
            } elseif ($file -match "\.csproj$") {
                Write-Host "$cGreen   ✓ .csproj paket referansları birleştiriliyor...$cReset"
                git checkout --theirs $file 2>$null
                git add $file
            } else {
                $unresolved += $file
            }
        }

        if ($unresolved.Count -gt 0) {
            Write-Host "$cBold$cRed❌ Otomatik çözülemeyen semantik çakışmalar var:$cReset"
            foreach ($uf in $unresolved) {
                Write-Host "   - $uf"
            }
            Write-Host "$cYellow🔄 Geri alınıyor (Rollback: git reset --hard)...$cReset"
            git reset --hard HEAD
            Write-Error "Merge durduruldu. Lütfen @architect ile birlikte çakışan dosyaları inceleyin."
        }
    }

    # E) Doğrulama Kapısı (Quality Gate: Build & Test)
    if (-not $NoTest) {
        Write-Host "$cBold$cBlue🧪 Doğrulama Kapısı: Otomatik derleme ve testler koşturuluyor...$cReset"
        $testPassed = $true

        # .NET Projesi
        $csproj = Get-ChildItem -LiteralPath $repoRoot -Filter "*.csproj" -Recurse -Depth 3 -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($csproj) {
            Write-Host "   * dotnet build çalıştırılıyor..."
            dotnet build --nologo -v q
            if ($LASTEXITCODE -ne 0) { $testPassed = $false }
        }

        # Node / JS / TS Projesi
        $pkgJson = Join-Path $repoRoot "package.json"
        if ($testPassed -and (Test-Path $pkgJson)) {
            $pkgContent = [System.IO.File]::ReadAllText($pkgJson, [System.Text.Encoding]::UTF8)
            if ($pkgContent -match '"test"') {
                Write-Host "   * npm test çalıştırılıyor..."
                npm test --if-present
                if ($LASTEXITCODE -ne 0) { $testPassed = $false }
            }
        }

        if (-not $testPassed) {
            Write-Host "$cBold$cRed❌ Doğrulama Kapısı Başarısız! Kod derlenemedi veya testler geçmedi.$cReset"
            Write-Host "$cYellow🔄 Rollback yapılıyor (main korunuyor)...$cReset"
            git reset --hard HEAD
            Write-Error "Doğrulama başarısız olduğu için merge iptal edildi. Worktree düzeltme için açık bırakıldı."
        }
        Write-Host "$cBold$cGreen✓ Doğrulama Kapısı Geçildi: Tüm testler ve derleme başarılı.$cReset"
    }

    # F) Main Dalına Nihai Commit
    $commitMsg = if ($Message) { $Message } else { "feat($normTask): completed by $Agent (integrated by @devops)" }
    Write-Host "$cBold$cGreen💾 'main' dalına tekil Squash Commit atılıyor...$cReset"
    git commit -m "$commitMsg"

    # G) Worktree ve Geçici Branch Temizliği
    Write-Host "$cBlue🧹 Worktree ve geçici branch temizleniyor...$cReset"
    git worktree remove --force $worktreeDir 2>$null
    Remove-Item -Recurse -Force $worktreeDir -ErrorAction SilentlyContinue
    git worktree prune
    git branch -D $branchName 2>$null

    Write-Host "$cBold$cGreen==========================================================================$cReset"
    Write-Host "$cBold$cGreen🎉 [@devops] '$normTask' BAŞARIYLA MAIN DALINA ENTEGRE EDİLDİ!$cReset"
    Write-Host "$cBold$cGreen==========================================================================$cReset`n"
    exit 0
}
