#!/usr/bin/env bash
# ==============================================================================
# AI OLAF TEAM - Seçici Hafıza Getirme Motoru (Selective Memory Retrieval)
# ==============================================================================
# Ajan çağrılarında tüm hafıza dosyalarını baştan sona yüklemek yerine,
# yalnızca görev için gerekli bölümü (section) on-demand çeker.
# Context token tüketimini %70-%88 oranında azaltır.
# ==============================================================================

set -eo pipefail
export PATH="/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_PATH=""

FILE_ARG=""
SECTION_ARG=""
TASK_ARG=""
AGENT_ARG=""
FULL_MODE=false
MAX_AGE_DAYS=0
LIST_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --file|-f)
            FILE_ARG="$2"
            shift 2
            ;;
        --section|-s)
            SECTION_ARG="$2"
            shift 2
            ;;
        --task|-t)
            TASK_ARG="$2"
            shift 2
            ;;
        --agent|-a)
            AGENT_ARG="$2"
            shift 2
            ;;
        --full)
            FULL_MODE=true
            shift
            ;;
        --max-age)
            MAX_AGE_DAYS="$2"
            shift 2
            ;;
        --list|-l|--list-sections)
            LIST_MODE=true
            shift
            ;;
        --root)
            ROOT_PATH="$2"
            shift 2
            ;;
        *)
            if [[ -z "$FILE_ARG" ]]; then
                FILE_ARG="$1"
            elif [[ -z "$SECTION_ARG" ]]; then
                SECTION_ARG="$1"
            fi
            shift
            ;;
    esac
done

# 1. GÜVENLİK KONTROLÜ - Path Traversal Koruması
if [[ -z "$FILE_ARG" ]]; then
    echo "HATA: Dosya parametresi (--file) belirtilmelidir." >&2
    exit 1
fi

if [[ "$FILE_ARG" =~ \.\. ]] || [[ "$FILE_ARG" =~ ^/etc ]] || [[ "$FILE_ARG" =~ ^[a-zA-Z]:\\ ]] || [[ "$FILE_ARG" =~ ^/var ]]; then
    echo "HATA: İzin verilmeyen dosya yolu: $FILE_ARG" >&2
    exit 1
fi

# 2. PROJE KÖK DİZİNİ TESPİTİ
if [[ -z "$ROOT_PATH" ]]; then
    if [[ -d "$SCRIPT_DIR/../templates" ]]; then
        ROOT_PATH="$(cd "$SCRIPT_DIR/.." && pwd)"
    else
        ROOT_PATH="$(pwd)"
    fi
fi

# 3. DOSYA HEDEFİ ÇÖZÜMLEME (FILE ALIAS RESOLUTION)
CLEAN_AGENT="${AGENT_ARG#@}"
CLEAN_TASK="$(echo "$TASK_ARG" | tr '[:lower:]' '[:upper:]')"

RESOLVED_FILE=""
FILE_DISPLAY_NAME="$FILE_ARG"

LOWER_FILE="$(echo "$FILE_ARG" | tr '[:upper:]' '[:lower:]')"

case "$LOWER_FILE" in
    brain|project-brain|project-brain.md)
        FILE_DISPLAY_NAME="project-brain.md"
        if [[ -f "$ROOT_PATH/.olaf/memory/project-brain.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/.olaf/memory/project-brain.md"
        elif [[ -f "$ROOT_PATH/templates/project-brain-template.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/templates/project-brain-template.md"
        fi
        ;;
    sprint|active-sprint|active-sprint.md)
        FILE_DISPLAY_NAME="active-sprint.md"
        if [[ -f "$ROOT_PATH/.olaf/memory/active-sprint.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/.olaf/memory/active-sprint.md"
        elif [[ -f "$ROOT_PATH/templates/active-sprint-template.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/templates/active-sprint-template.md"
        fi
        ;;
    skills|skill|learned-skills)
        if [[ -z "$CLEAN_AGENT" ]]; then
            echo "HATA: Skills sorgusu için --agent parametresi gereklidir. Örn: --agent backend" >&2
            exit 1
        fi
        FILE_DISPLAY_NAME="$CLEAN_AGENT-skills.md"
        if [[ -f "$ROOT_PATH/.olaf/learned-skills/$CLEAN_AGENT-skills.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/.olaf/learned-skills/$CLEAN_AGENT-skills.md"
        elif [[ -f "$ROOT_PATH/templates/learned-skill-template.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/templates/learned-skill-template.md"
        fi
        ;;
    brief|context|task-context)
        if [[ -z "$CLEAN_TASK" ]]; then
            echo "HATA: Brief sorgusu için --task parametresi gereklidir. Örn: --task TASK-01" >&2
            exit 1
        fi
        FILE_DISPLAY_NAME="$CLEAN_TASK-brief.md"
        if [[ -f "$ROOT_PATH/.olaf/contexts/$CLEAN_TASK-brief.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/.olaf/contexts/$CLEAN_TASK-brief.md"
        elif [[ -f "$ROOT_PATH/templates/task-context-brief-template.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/templates/task-context-brief-template.md"
        fi
        ;;
    output|task-output)
        if [[ -z "$CLEAN_TASK" ]]; then
            echo "HATA: Output sorgusu için --task parametresi gereklidir. Örn: --task TASK-01" >&2
            exit 1
        fi
        FILE_DISPLAY_NAME="$CLEAN_TASK-output.md"
        if [[ -f "$ROOT_PATH/.olaf/outputs/$CLEAN_TASK-output.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/.olaf/outputs/$CLEAN_TASK-output.md"
        elif [[ -f "$ROOT_PATH/templates/task-output-template.md" ]]; then
            RESOLVED_FILE="$ROOT_PATH/templates/task-output-template.md"
        fi
        ;;
    *)
        CANDIDATE="$ROOT_PATH/$FILE_ARG"
        if [[ -f "$CANDIDATE" ]]; then
            # Sadece .olaf veya templates altındaki dosyalara izin verilir
            CANONICAL="$(cd "$(dirname "$CANDIDATE")" && pwd)/$(basename "$CANDIDATE")"
            if [[ "$CANONICAL" == "$ROOT_PATH/.olaf"* ]] || [[ "$CANONICAL" == "$ROOT_PATH/templates"* ]]; then
                RESOLVED_FILE="$CANDIDATE"
                FILE_DISPLAY_NAME="$(basename "$CANDIDATE")"
            else
                echo "HATA: İzin verilmeyen dosya yolu: $FILE_ARG" >&2
                exit 1
            fi
        fi
        ;;
esac

if [[ -z "$RESOLVED_FILE" ]] || [[ ! -f "$RESOLVED_FILE" ]]; then
    echo "HATA: Hedef hafıza dosyası bulunamadı: $FILE_ARG" >&2
    exit 1
fi

# 4. GERİYE DÖNÜK UYUMLULUK: --full
if [[ "$FULL_MODE" == true ]]; then
    cat "$RESOLVED_FILE"
    exit 0
fi

# 5. BÖLÜM LİSTELEME: --list
if [[ "$LIST_MODE" == true ]]; then
    echo "📂 Mevcut Bölüm Anahtarları ($FILE_DISPLAY_NAME):"
    grep -E '^##[[:space:]]+KEY:[[:space:]]*[a-zA-Z0-9_\-]+' "$RESOLVED_FILE" | sed -E 's/^##[[:space:]]+KEY:[[:space:]]*/  - /' || echo "  (Tanımlı ## KEY: etiketi bulunamadı)"
    exit 0
fi

# 6. SPRINT GÖREV SATIRI ÇEKME (--task ile active-sprint sorgusu)
if [[ "$LOWER_FILE" =~ ^(sprint|active-sprint|active-sprint\.md)$ ]] && [[ -n "$CLEAN_TASK" ]] && [[ -z "$SECTION_ARG" ]]; then
    HEADER=$(grep -E '^\|[[:space:]]*Kulvar[[:space:]]*\/[[:space:]]*Faz' "$RESOLVED_FILE" || true)
    SEP=$(grep -E '^\|[[:space:]]*:---' "$RESOLVED_FILE" || true)
    ROW=$(grep -E "\|[[:space:]]*\`?$CLEAN_TASK\`?[[:space:]]*\|" "$RESOLVED_FILE" || true)

    if [[ -n "$ROW" ]]; then
        echo "## SPRINT GÖREVİ: $CLEAN_TASK"
        [[ -n "$HEADER" ]] && echo "$HEADER"
        [[ -n "$SEP" ]] && echo "$SEP"
        echo "$ROW"
        exit 0
    fi
fi

# 7. BÖLÜM (SECTION) SORGULAMA
TARGET_KEY="${SECTION_ARG:-$CLEAN_TASK}"

if [[ -z "$TARGET_KEY" ]]; then
    echo "HATA: Lütfen getirmek istediğiniz bölümü (--section) veya görevi (--task) belirtin. Tam dosya için: --full" >&2
    exit 1
fi

# AWK ile ilgili bölümü çek
SECTION_OUTPUT=$(awk -v target="$TARGET_KEY" '
    BEGIN {
        in_section = 0
        found = 0
        target_lower = tolower(target)
    }
    /^##[[:space:]]+KEY:[[:space:]]*/ {
        key = $0
        sub(/^##[[:space:]]+KEY:[[:space:]]*/, "", key)
        gsub(/[[:space:]]+.*/, "", key)
        if (tolower(key) == target_lower) {
            in_section = 1
            found = 1
            print $0
            next
        } else if (in_section == 1) {
            in_section = 0
            exit
        }
    }
    /^##[[:space:]]+[^#]/ {
        if (in_section == 1) {
            in_section = 0
            exit
        }
    }
    {
        if (in_section == 1) {
            print $0
        }
    }
    END {
        if (found == 0) {
            exit 2
        }
    }
' "$RESOLVED_FILE" || true)

# Fallback anahtar arama
if [[ -z "$SECTION_OUTPUT" ]]; then
    ALIAS_PATTERN=""
    case "$(echo "$TARGET_KEY" | tr '[:upper:]' '[:lower:]')" in
        tech-stack)      ALIAS_PATTERN="TEKNOLOJİ YIĞINI" ;;
        overview)        ALIAS_PATTERN="PROJE KİMLİĞİ" ;;
        architecture)    ALIAS_PATTERN="MİMARİ YAPI" ;;
        database)        ALIAS_PATTERN="VERİTABANI" ;;
        api)             ALIAS_PATTERN="API STANDARTLARI" ;;
        security)        ALIAS_PATTERN="GÜVENLİK" ;;
        devops)          ALIAS_PATTERN="DEVOPS" ;;
        git-history)     ALIAS_PATTERN="GİT GEÇMİŞİ" ;;
        team-agreement)  ALIAS_PATTERN="TAKIM ANLAŞMASI" ;;
        sprint-goal)     ALIAS_PATTERN="SPRINT HEDEFİ" ;;
        task-board)      ALIAS_PATTERN="GÖREV DAĞILIMI" ;;
        conventions)     ALIAS_PATTERN="KODLAMA VE TASARIM STANDARTLARI" ;;
        models)          ALIAS_PATTERN="İLİŞKİLİ VERİ" ;;
        anti-patterns)   ALIAS_PATTERN="ASLA YAPILMAYACAKLAR|DİKKAT EDİLECEK" ;;
        checklist)       ALIAS_PATTERN="ZORUNLU YAPILACAKLAR|KONTROL LİSTESİ" ;;
        acceptance)      ALIAS_PATTERN="GÖREV TANIMI VE KABUL KRİTERLERİ" ;;
        scope)           ALIAS_PATTERN="DOSYA KAPSAMI" ;;
        dependencies)    ALIAS_PATTERN="BAĞIMLILIKLAR" ;;
        output)          ALIAS_PATTERN="TESLİMAT VE ÇIKTI" ;;
        *)               ALIAS_PATTERN="$TARGET_KEY" ;;
    esac

    SECTION_OUTPUT=$(awk -v pattern="$ALIAS_PATTERN" '
        BEGIN {
            in_section = 0
            found = 0
        }
        /^##[[:space:]]+/ {
            if ($0 ~ pattern) {
                in_section = 1
                found = 1
                print $0
                next
            } else if (in_section == 1) {
                in_section = 0
                exit
            }
        }
        {
            if (in_section == 1) {
                print $0
            }
        }
    ' "$RESOLVED_FILE" || true)
fi

if [[ -z "$SECTION_OUTPUT" ]]; then
    echo "HATA: '$TARGET_KEY' bölümü '$FILE_DISPLAY_NAME' içinde bulunamadı." >&2
    exit 1
fi

# 8. GÜNCELLİK KONTROLÜ (--max-age)
if [[ $MAX_AGE_DAYS -gt 0 ]]; then
    DATE_STR=$(echo "$SECTION_OUTPUT" | grep -oE '<!--[[:space:]]*updated:[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -n1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' || true)
    if [[ -z "$DATE_STR" ]]; then
        DATE_STR=$(grep -oE 'Son Güncelleme:\*\*[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$RESOLVED_FILE" | head -n1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' || true)
    fi

    if [[ -n "$DATE_STR" ]]; then
        # Tarih farkını hesapla (Unix epoch)
        TARGET_EPOCH=$(date -d "$DATE_STR" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$DATE_STR" +%s 2>/dev/null || echo "")
        NOW_EPOCH=$(date +%s)
        if [[ -n "$TARGET_EPOCH" ]]; then
            DIFF_DAYS=$(( (NOW_EPOCH - TARGET_EPOCH) / 86400 ))
            if [[ $DIFF_DAYS -gt $MAX_AGE_DAYS ]]; then
                echo "⚠️  UYARI: $FILE_DISPLAY_NAME §$TARGET_KEY $DIFF_DAYS günden eski (son güncelleme: $DATE_STR)"
            fi
        fi
    fi
fi

# 9. ÇIKTIYI YAZDIR
echo "$SECTION_OUTPUT"
exit 0
