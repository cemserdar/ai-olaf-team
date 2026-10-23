#!/usr/bin/env bash
# ==============================================================================
# AI OLAF TEAM - PRE-COMMIT HOOK & LINT ENTEGRASYON TESTİ (demo-hook-test.sh)
# ==============================================================================
# Bu betik, geçici izole bir Git deposu kurarak:
# 1. Projenin mevcut pre-commit kontrollerinin (lint/test) korunduğunu,
# 2. Lint hata verdiğinde commit işleminin durduğunu,
# 3. Hata düzeltildiğinde commit'in başarıyla gerçekleştiğini,
# 4. Olaf yönetim ve hafıza dosyalarının repoya asla sızmadığını
# doğrular.
# ==============================================================================

set -e

COLOR_RESET="\033[0m"
COLOR_BOLD="\033[1m"
COLOR_CYAN="\033[36m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_RED="\033[31m"

echo -e "\n${COLOR_BOLD}${COLOR_CYAN}==========================================================================${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_CYAN}    🧪 AI OLAF TEAM - PRE-COMMIT HOOK VE GHOST MODU CANLI DOĞRULAMA (BASH)${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_CYAN}==========================================================================${COLOR_RESET}\n"

OLAF_CENTRAL="$(pwd)"
INIT_SCRIPT="$OLAF_CENTRAL/scripts/olaf-init.sh"

if [ ! -f "$INIT_SCRIPT" ]; then
    echo -e "${COLOR_RED}Hata: olaf-init.sh bulunamadı: $INIT_SCRIPT${COLOR_RESET}"
    exit 1
fi

DEMO_DIR="/tmp/olaf-hook-demo-$RANDOM"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

cleanup() {
    cd "$OLAF_CENTRAL"
    rm -rf "$DEMO_DIR" 2>/dev/null || true
}
trap cleanup EXIT

echo -e "${COLOR_BOLD}[Adım 1/5]${COLOR_RESET} Geçici izole Git projesi oluşturuluyor..."
git init -q
git config user.email "test@olaf-team.local"
git config user.name "Olaf Tester"

echo -e "${COLOR_BOLD}[Adım 2/5]${COLOR_RESET} Projenin kendi orijinal LINT kontrolü kancaya ekleniyor..."
mkdir -p .git/hooks
cat << 'EOF' > .git/hooks/pre-commit
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
EOF
chmod +x .git/hooks/pre-commit

echo -e "${COLOR_BOLD}[Adım 3/5]${COLOR_RESET} 'olaf-init' çalıştırılarak Olaf ekibi bağlanıyor..."
export AI_OLAF_TEAM_DIR="$OLAF_CENTRAL"
bash "$INIT_SCRIPT" >/dev/null 2>&1 || true

if grep -q "PROJENIN MEVCUT LINT/TEST KONTROLU" .git/hooks/pre-commit && grep -q "AI OLAF TEAM PRE-COMMIT GUARD" .git/hooks/pre-commit; then
    echo -e "   ${COLOR_GREEN}✓ Hook Birleşimi Başarılı:${COLOR_RESET} Orijinal lint kodu silinmedi, Olaf Guard eklendi."
else
    echo -e "   ${COLOR_RED}❌ Hata: Hook birleşimi başarısız!${COLOR_RESET}"
    exit 1
fi

echo -e "\n${COLOR_BOLD}[Adım 4/5 - SENARYO A]${COLOR_RESET} Kasıtlı lint hatası içeren dosya ile commit deneniyor..."
mkdir -p src
echo "const x = 'KASITLI_LINT_HATASI';" > src/app.js

git add src/app.js
git add GEMINI.md -f 2>/dev/null || true

set +e
git commit -m "feat: hatali commit denemesi" >/dev/null 2>&1
COMMIT_EXIT=$?
set -e

if [ $COMMIT_EXIT -ne 0 ]; then
    echo -e "   ${COLOR_GREEN}✓ BEKLENEN DAVRANIŞ:${COLOR_RESET} Lint hatası nedeniyle commit DURDURULDU (Engellendi)."
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
        echo -e "   ${COLOR_GREEN}✓ DOĞRULAMA:${COLOR_RESET} Git geçmişinde hiçbir commit oluşmadı (temiz)."
    fi
else
    echo -e "   ${COLOR_RED}❌ BAŞARISIZ:${COLOR_RESET} Lint hatasına rağmen commit atılabildi!"
    exit 1
fi

echo -e "\n${COLOR_BOLD}[Adım 5/5 - SENARYO B]${COLOR_RESET} Lint hatası düzeltilip tekrar commit deneniyor..."
echo "const x = 'TEMIZ_KOD';" > src/app.js
git add src/app.js
git add GEMINI.md -f 2>/dev/null || true

set +e
git commit -m "feat: temiz kod ile basarili commit" >/dev/null 2>&1
COMMIT_EXIT2=$?
set -e

if [ $COMMIT_EXIT2 -eq 0 ]; then
    echo -e "   ${COLOR_GREEN}✓ BEKLENEN DAVRANIŞ:${COLOR_RESET} Hata düzeltilince commit BAŞARIYLA tamamlandı."
    COMMITTED_FILES=$(git show --pretty="" --name-only HEAD)
    echo "   📦 Commit'e dahil edilen dosyalar:"
    echo "$COMMITTED_FILES" | while read -r f; do
        if [ -n "$f" ]; then echo "      - $f"; fi
    done

    if echo "$COMMITTED_FILES" | grep -qE "GEMINI|\.olaf"; then
        echo -e "   ${COLOR_RED}❌ SIZINTI TESPİT EDİLDİ:${COLOR_RESET} Olaf dosyaları commit içine girmiş!"
        exit 1
    else
        echo -e "   ${COLOR_BOLD}${COLOR_GREEN}✓ GHOST MODU KORUNDU:${COLOR_RESET} Olaf dosyaları repoya sızmadı, yalnızca kaynak kodu commit edildi."
    fi
else
    echo -e "   ${COLOR_RED}❌ BAŞARISIZ:${COLOR_RESET} Düzeltilmiş kod commit edilemedi!"
    exit 1
fi

echo -e "\n${COLOR_BOLD}${COLOR_GREEN}==========================================================================${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_GREEN}    🎉 TÜM DOĞRULAMA TESTLERİ BAŞARIYLA GEÇTİ! [PASS]${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_GREEN}    1. Mevcut lint/test kancası korundu ve hatalı commiti durdurdu.${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_GREEN}    2. Hata düzeltilince commit devam etti.${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_GREEN}    3. Olaf dosyaları un-staged edilerek repo temiz tutuldu.${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_GREEN}==========================================================================${COLOR_RESET}\n"
