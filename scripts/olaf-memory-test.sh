#!/usr/bin/env bash
# ==============================================================================
# AI OLAF TEAM - Seçici Hafıza Doğrulama Test Koşucusu (BASH)
# ==============================================================================

set -eo pipefail
export PATH="/usr/bin:/bin:$PATH"

COLOR_RESET="\033[0m"
COLOR_BOLD="\033[1m"
COLOR_CYAN="\033[36m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_RED="\033[31m"

echo -e "\n${COLOR_BOLD}${COLOR_CYAN}==========================================================================${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_CYAN}    🧪 AI OLAF TEAM - SEÇİCİ HAFIZA (SELECTIVE RETRIEVAL) TESTLERİ (BASH)${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_CYAN}==========================================================================${COLOR_RESET}\n"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUERY_SCRIPT="$SCRIPT_DIR/olaf-query-memory.sh"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_BRAIN="$PROJECT_ROOT/templates/project-brain-template.md"

if [ ! -f "$QUERY_SCRIPT" ]; then
    echo -e "${COLOR_RED}[BAŞARISIZ] olaf-query-memory.sh bulunamadı: $QUERY_SCRIPT${COLOR_RESET}"
    exit 1
fi

PASS_COUNT=0
FAIL_COUNT=0

report_result() {
    local name="$1"
    local passed="$2"
    local details="$3"

    if [ "$passed" -eq 1 ]; then
        PASS_COUNT=$((PASS_COUNT + 1))
        echo -e "${COLOR_GREEN}[GEÇTİ] $name${COLOR_RESET}"
        [ -n "$details" ] && echo -e "        $details"
    else
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo -e "${COLOR_RED}[BAŞARISIZ] $name${COLOR_RESET}"
        [ -n "$details" ] && echo -e "        ${COLOR_YELLOW}$details${COLOR_RESET}"
    fi
}

# --- TEST A: Token & Satır Tasarrufu Ölçümü ---
echo -e "${COLOR_BOLD}▶ Test A: Token & Satır Tasarrufu Ölçümü${COLOR_RESET}"
FULL_LINES=$(wc -l < "$TEMPLATE_BRAIN" | tr -d ' ')
SELECTIVE_OUTPUT=$(bash "$QUERY_SCRIPT" -f brain -s tech-stack)
SELECTIVE_LINES=$(echo "$SELECTIVE_OUTPUT" | wc -l | tr -d ' ')
MAX_ALLOWED=$(( FULL_LINES * 30 / 100 ))

if [ "$SELECTIVE_LINES" -le "$MAX_ALLOWED" ]; then
    TEST_A_PASSED=1
else
    TEST_A_PASSED=0
fi
report_result "Test A - Token Tasarrufu" $TEST_A_PASSED "Tam dosya: $FULL_LINES satır | Seçici: $SELECTIVE_LINES satır (Hedef: <= $MAX_ALLOWED satır)"

# --- TEST B: Doğru Bölüm İzolasyonu ---
echo -e "\n${COLOR_BOLD}▶ Test B: Doğru Bölüm İzolasyonu${COLOR_RESET}"
HAS_TECH=0
NOT_HAS_ARCH=0
if echo "$SELECTIVE_OUTPUT" | grep -q "## KEY: tech-stack"; then
    HAS_TECH=1
fi
if ! echo "$SELECTIVE_OUTPUT" | grep -q "## KEY: architecture"; then
    NOT_HAS_ARCH=1
fi

if [ $HAS_TECH -eq 1 ] && [ $NOT_HAS_ARCH -eq 1 ]; then
    TEST_B_PASSED=1
else
    TEST_B_PASSED=0
fi
report_result "Test B - Bölüm İzolasyonu" $TEST_B_PASSED "Hedef KEY bulundu: $HAS_TECH | İlgisiz KEY izole edildi: $NOT_HAS_ARCH"

# --- TEST C: Güncellik Uyarısı ---
echo -e "\n${COLOR_BOLD}▶ Test C: Güncellik (Freshness) Uyarısı${COLOR_RESET}"
RESULT_C=$(bash "$QUERY_SCRIPT" -f brain -s tech-stack --max-age 7 2>&1 || true)
if echo "$RESULT_C" | grep -q "⚠️  UYARI"; then
    TEST_C_PASSED=1
else
    TEST_C_PASSED=0
fi
report_result "Test C - Güncellik Uyarısı" $TEST_C_PASSED "8 günlük tech-stack bölümü için '--max-age 7' uyarısı tetiklendi: $TEST_C_PASSED"

# --- TEST D: Sınır Dışı Güvenlik (Path Traversal) ---
echo -e "\n${COLOR_BOLD}▶ Test D: Güvenlik Sınırı & Traversal Engelleme${COLOR_RESET}"
set +e
ERR_OUT=$(bash "$QUERY_SCRIPT" -f "../../etc/passwd" -s all 2>&1)
EXIT_CODE=$?
set -eo pipefail

if echo "$ERR_OUT" | grep -q "HATA: İzin verilmeyen dosya yolu" && [ "$EXIT_CODE" -eq 1 ]; then
    TEST_D_PASSED=1
else
    TEST_D_PASSED=0
fi
report_result "Test D - Dizin Kaçış Güvenliği" $TEST_D_PASSED "Çıkış Kodu: $EXIT_CODE (Beklenen: 1) | Traversal engellendi: $TEST_D_PASSED"

# --- TEST E: Geriye Dönük Uyumluluk (--full) ---
echo -e "\n${COLOR_BOLD}▶ Test E: Geriye Dönük Uyumluluk (--full)$cReset"
RESULT_E=$(bash "$QUERY_SCRIPT" -f brain --full)
FULL_OUT_LINES=$(echo "$RESULT_E" | wc -l | tr -d ' ')

if [ "$FULL_OUT_LINES" -eq "$FULL_LINES" ]; then
    TEST_E_PASSED=1
else
    TEST_E_PASSED=0
fi
report_result "Test E - Tam Yükleme Uyumluluğu" $TEST_E_PASSED "Beklenen: $FULL_LINES satır | Alınan: $FULL_OUT_LINES satır"

# --- ÖZET RAPOR ---
echo -e "\n${COLOR_BOLD}${COLOR_CYAN}==========================================================================${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_CYAN}    TEST ÖZETİ: $PASS_COUNT GEÇTİ, $FAIL_COUNT BAŞARISIZ${COLOR_RESET}"
echo -e "${COLOR_BOLD}${COLOR_CYAN}==========================================================================${COLOR_RESET}\n"

if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi
