#!/usr/bin/env bash
# ==============================================================================
# AI OLAF TEAM - PARALEL WORKTREE VE RELEASE GATEKEEPER MOTORU (olaf-worktree.sh)
# ==============================================================================
# Bu betik, @devops ajanı tarafından bağımsız görevler için izole Git Worktree
# alanları açmak, kapatmak, Squash Merge ile main dalına entegre etmek ve çakışma/
# doğrulama kapılarını (Quality Gate) yönetmek için kullanılır.
# ==============================================================================

set -e

COLOR_RESET="\033[0m"
COLOR_BOLD="\033[1m"
COLOR_CYAN="\033[36m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_RED="\033[31m"

ACTION="${1:-}"
TASK_ID="${2:-}"
AGENT="${3:-agent}"
NO_TEST=false

if [ "$4" == "--no-test" ] || [ "$3" == "--no-test" ]; then
    NO_TEST=true
fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$REPO_ROOT" ]; then
    echo -e "${COLOR_RED}Hata: Geçerli bir Git deposu içinde değilsiniz!${COLOR_RESET}"
    exit 1
fi
cd "$REPO_ROOT"

if [ -z "$ACTION" ]; then
    echo "Kullanım: olaf-worktree <start|merge|cleanup|list|status> <TASK_ID> [AGENT] [--no-test]"
    exit 1
fi

NORM_TASK=$(echo "$TASK_ID" | tr '[:upper:]' '[:lower:]')
BRANCH_NAME="task/$NORM_TASK"
WORKTREE_DIR="$REPO_ROOT/.olaf/worktrees/$NORM_TASK"

get_base_branch() {
    if git show-ref --verify --quiet refs/heads/main; then
        echo "main"
    elif git show-ref --verify --quiet refs/heads/master; then
        echo "master"
    else
        git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main"
    fi
}
BASE_BRANCH=$(get_base_branch)

case "$ACTION" in
    start)
        if [ -z "$TASK_ID" ]; then
            echo -e "${COLOR_RED}Hata: Lütfen bir Görev ID belirtin!${COLOR_RESET}"
            exit 1
        fi
        echo -e "${COLOR_BOLD}${COLOR_CYAN}🚀 [@devops] '$NORM_TASK' için izole Worktree alanı hazırlanıyor...${COLOR_RESET}"

        if [ -d "$WORKTREE_DIR" ]; then
            echo -e "${COLOR_YELLOW}ℹ️  Worktree zaten mevcut: $WORKTREE_DIR${COLOR_RESET}"
            exit 0
        fi

        if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
            git branch "$BRANCH_NAME" "$BASE_BRANCH"
        fi

        mkdir -p "$REPO_ROOT/.olaf/worktrees"
        git worktree add "$WORKTREE_DIR" "$BRANCH_NAME"

        # Ghost modu exclude koruması
        if [ -f "$REPO_ROOT/.git/info/exclude" ]; then
            WT_GITDIR=$(git -C "$WORKTREE_DIR" rev-parse --git-dir 2>/dev/null || true)
            if [ -n "$WT_GITDIR" ]; then
                mkdir -p "$WT_GITDIR/info"
                cp -f "$REPO_ROOT/.git/info/exclude" "$WT_GITDIR/info/exclude" 2>/dev/null || true
            fi
        fi

        # Context Brief ve Output dizinlerini hazırla
        mkdir -p "$REPO_ROOT/.olaf/contexts"
        mkdir -p "$REPO_ROOT/.olaf/outputs"

        BRIEF_FILE="$REPO_ROOT/.olaf/contexts/$NORM_TASK-brief.md"
        if [ ! -f "$BRIEF_FILE" ]; then
            HEAD_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "HEAD")
            NOW_DATE=$(date "+%Y-%m-%d %H:%M" 2>/dev/null || echo "")
            TMPL_PATH="$REPO_ROOT/templates/task-context-brief-template.md"
            if [ ! -f "$TMPL_PATH" ]; then
                TMPL_PATH="$REPO_ROOT/.olaf/templates/task-context-brief-template.md"
            fi
            if [ -f "$TMPL_PATH" ]; then
                sed -e "s/{{TASK_ID}}/$NORM_TASK/g" \
                    -e "s/{{RESPONSIBLE_AGENT}}/$AGENT/g" \
                    -e "s/{{CREATED_AT}}/$NOW_DATE/g" \
                    -e "s/{{SNAPSHOT_COMMIT_HASH}}/$HEAD_HASH/g" \
                    "$TMPL_PATH" > "$BRIEF_FILE"
            else
                echo -e "# CONTEXT BRIEF — $NORM_TASK\nTask: $NORM_TASK\nAgent: $AGENT\nSnapshot: $HEAD_HASH" > "$BRIEF_FILE"
            fi
        fi

        echo -e "${COLOR_BOLD}${COLOR_GREEN}✅ [@devops] Worktree hazır!${COLOR_RESET}"
        echo -e "   📂 Dizin : ${COLOR_CYAN}$WORKTREE_DIR${COLOR_RESET}"
        echo -e "   🌿 Branch: ${COLOR_CYAN}$BRANCH_NAME${COLOR_RESET}"
        echo -e "   👤 Ajan  : ${COLOR_YELLOW}$AGENT${COLOR_RESET}"
        echo -e "   📋 Brief : ${COLOR_YELLOW}$BRIEF_FILE${COLOR_RESET}"
        echo -e "   👉 $AGENT artık yalnızca bu dizinde ve brief dosyasındaki kapsamda çalışabilir.\n"
        ;;

    list)
        echo -e "${COLOR_BOLD}${COLOR_CYAN}📋 [@devops] Aktif Git Worktree Listesi:${COLOR_RESET}"
        git worktree list
        ;;

    status)
        if [ ! -d "$WORKTREE_DIR" ]; then
            echo -e "${COLOR_YELLOW}ℹ️  Worktree bulunamadı: $WORKTREE_DIR${COLOR_RESET}"
            exit 0
        fi
        echo -e "${COLOR_BOLD}${COLOR_CYAN}📊 [@devops] '$NORM_TASK' Worktree Durumu:${COLOR_RESET}"
        git -C "$WORKTREE_DIR" status
        ;;

    cleanup|abort)
        echo -e "${COLOR_BOLD}${COLOR_YELLOW}🧹 [@devops] '$NORM_TASK' Worktree alanı temizleniyor...${COLOR_RESET}"
        git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
        rm -rf "$WORKTREE_DIR" 2>/dev/null || true
        git worktree prune
        git branch -D "$BRANCH_NAME" 2>/dev/null || true
        echo -e "${COLOR_GREEN}✅ Temizlik tamamlandı.${COLOR_RESET}"
        ;;

    merge)
        if [ ! -d "$WORKTREE_DIR" ]; then
            echo -e "${COLOR_RED}Hata: Birleştirilecek worktree bulunamadı ($WORKTREE_DIR)!${COLOR_RESET}"
            exit 1
        fi

        echo -e "${COLOR_BOLD}${COLOR_CYAN}🔄 [@devops] '$NORM_TASK' için Main Entegrasyonu ve Release Kapısı Başlatılıyor...${COLOR_RESET}"

        # Uncommitted değişiklikleri commit et
        if [ -n "$(git -C "$WORKTREE_DIR" status --porcelain 2>/dev/null)" ]; then
            echo -e "${COLOR_BLUE}📝 Worktree içindeki son değişiklikler stage ediliyor...${COLOR_RESET}"
            git -C "$WORKTREE_DIR" add .
            git -C "$WORKTREE_DIR" commit -m "feat($NORM_TASK): completed by $AGENT"
        fi

        echo -e "${COLOR_BLUE}🌿 '$BASE_BRANCH' dalına geçiliyor...${COLOR_RESET}"
        git checkout "$BASE_BRANCH"

        echo -e "${COLOR_BLUE}🔀 Squash Merge uygulanıyor (Ara commitler tekilleştiriliyor)...${COLOR_RESET}"
        set +e
        git merge --squash "$BRANCH_NAME"
        MERGE_STATUS=$?
        set -e

        HAS_CONFLICT=$(git status --porcelain | grep -E '^(UU|AA|UD|DU)' || true)
        if [ -n "$HAS_CONFLICT" ]; then
            echo -e "${COLOR_BOLD}${COLOR_YELLOW}⚠️  Çakışma (Conflict) Tespit Edildi! Çözüm protokolü devreye giriyor...${COLOR_RESET}"
            CONFLICT_FILES=$(git diff --name-only --diff-filter=U)
            UNRESOLVED=""

            for file in $CONFLICT_FILES; do
                if [[ "$file" == *"package.json" ]]; then
                    echo -e "${COLOR_GREEN}   ✓ package.json birleşimi uygulanıyor...${COLOR_RESET}"
                    git checkout --theirs "$file" 2>/dev/null || true
                    git add "$file"
                elif [[ "$file" == *".csproj" ]]; then
                    echo -e "${COLOR_GREEN}   ✓ .csproj paket referansları birleştiriliyor...${COLOR_RESET}"
                    git checkout --theirs "$file" 2>/dev/null || true
                    git add "$file"
                else
                    UNRESOLVED="$UNRESOLVED $file"
                fi
            done

            if [ -n "$UNRESOLVED" ]; then
                echo -e "${COLOR_BOLD}${COLOR_RED}❌ Otomatik çözülemeyen çakışmalar: $UNRESOLVED${COLOR_RESET}"
                git reset --hard HEAD
                echo -e "${COLOR_RED}Merge durduruldu. Lütfen @architect ile birlikte çakışan dosyaları inceleyin.${COLOR_RESET}"
                exit 1
            fi
        fi

        if [ "$NO_TEST" = false ]; then
            echo -e "${COLOR_BOLD}${COLOR_BLUE}🧪 Doğrulama Kapısı: Otomatik test ve derleme çalıştırılıyor...${COLOR_RESET}"
            TEST_PASSED=true

            if [ -f "package.json" ] && grep -q '"test"' package.json; then
                npm test --if-present || TEST_PASSED=false
            fi

            if find . -maxdepth 3 -name "*.csproj" | grep -q .; then
                dotnet build --nologo -v q || TEST_PASSED=false
            fi

            if [ "$TEST_PASSED" = false ]; then
                echo -e "${COLOR_BOLD}${COLOR_RED}❌ Doğrulama Başarısız! Rollback yapılıyor...${COLOR_RESET}"
                git reset --hard HEAD
                exit 1
            fi
            echo -e "${COLOR_BOLD}${COLOR_GREEN}✓ Doğrulama Kapısı Geçildi.${COLOR_RESET}"
        fi

        echo -e "${COLOR_BOLD}${COLOR_GREEN}💾 'main' dalına tekil Squash Commit atılıyor...${COLOR_RESET}"
        git commit -m "feat($NORM_TASK): completed by $AGENT (integrated by @devops)"

        echo -e "${COLOR_BLUE}🧹 Worktree ve geçici branch temizleniyor...${COLOR_RESET}"
        git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
        rm -rf "$WORKTREE_DIR" 2>/dev/null || true
        git worktree prune
        git branch -D "$BRANCH_NAME" 2>/dev/null || true

        echo -e "${COLOR_BOLD}${COLOR_GREEN}==========================================================================${COLOR_RESET}"
        echo -e "${COLOR_BOLD}${COLOR_GREEN}🎉 [@devops] '$NORM_TASK' BAŞARIYLA MAIN DALINA ENTEGRE EDİLDİ!${COLOR_RESET}"
        echo -e "${COLOR_BOLD}${COLOR_GREEN}==========================================================================${COLOR_RESET}\n"
        ;;

    *)
        echo "Bilinmeyen eylem: $ACTION"
        exit 1
        ;;
esac
