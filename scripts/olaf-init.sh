#!/usr/bin/env bash
# ==============================================================================
# AI OLAF TEAM - OTONOM YAZILIM TAKIMI PROJE ENTEGRASYON MOTORU (olaf-init)
# ==============================================================================
# Bu betik, çalıştırıldığı herhangi bir projeye "AI Olaf Team" 15 kişilik otonom
# ekibini bağlar, projenin röntgenini çeker, hafıza ve kural köprülerini kurar.
# ==============================================================================

set -e

# Renk Tanımları
COLOR_RESET="\033[0m"
COLOR_BOLD="\033[1m"
COLOR_CYAN="\033[36m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_MAGENTA="\033[35m"
COLOR_RED="\033[31m"

# Başlık Banner'ı
echo -e "${COLOR_CYAN}${COLOR_BOLD}"
echo "=========================================================================="
echo "    🚀 AI OLAF TEAM - OTONOM YAZILIM TAKIMI ENTEGRASYON MOTORU          "
echo "=========================================================================="
echo -e "${COLOR_RESET}"

# 1. AI OLAF TEAM MERKEZİ REPO DİZİNİNİ TESPİT ET
OLAF_CENTRAL_DIR=""

if [ -n "$AI_OLAF_TEAM_DIR" ] && [ -d "$AI_OLAF_TEAM_DIR/base-agents" ]; then
    OLAF_CENTRAL_DIR="$AI_OLAF_TEAM_DIR"
elif [ -d "$HOME/ai-olaf-team/base-agents" ]; then
    OLAF_CENTRAL_DIR="$HOME/ai-olaf-team"
else
    # Betiğin kendi bulunduğu klasör üzerinden üst dizini kontrol et
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -d "$SCRIPT_DIR/../base-agents" ]; then
        OLAF_CENTRAL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
    fi
fi

if [ -z "$OLAF_CENTRAL_DIR" ] || [ ! -d "$OLAF_CENTRAL_DIR/base-agents" ]; then
    echo -e "${COLOR_RED}❌ HATA: AI Olaf Team merkezi repo dizini bulunamadı!${COLOR_RESET}"
    echo -e "Lütfen repo dizinini şu şekilde belirtin: export AI_OLAF_TEAM_DIR=/path/to/ai-olaf-team"
    exit 1
fi

echo -e "${COLOR_GREEN}✓ Merkezi Ekip Dizini:${COLOR_RESET} $OLAF_CENTRAL_DIR"

TARGET_DIR="$(pwd)"
PROJECT_NAME="$(basename "$TARGET_DIR")"
echo -e "${COLOR_GREEN}✓ Hedef Proje Dizini:${COLOR_RESET}  $TARGET_DIR"
echo -e "${COLOR_GREEN}✓ Hedef Proje Adı:${COLOR_RESET}     $PROJECT_NAME"

# 2. .olaf DİZİN YAPISINI OLUŞTUR
echo -e "\n${COLOR_BLUE}📂 .olaf Hafıza ve Yetenek Dizinleri Oluşturuluyor...${COLOR_RESET}"
mkdir -p "$TARGET_DIR/.olaf/base-agents"
mkdir -p "$TARGET_DIR/.olaf/learned-skills"
mkdir -p "$TARGET_DIR/.olaf/memory"

# Merkezi base-agents dosyalarını hedef projeye kopyala
cp -r "$OLAF_CENTRAL_DIR/base-agents/"*.md "$TARGET_DIR/.olaf/base-agents/"

# 3. 15 AJAN İÇİN LEARNED-SKILLS DOSYALARINI BAŞLAT
AGENTS_LIST=(
    "pm:Proje Yöneticisi & Takım Orkestra Şefi:@pm"
    "architect:Baş Yazılım Mimarı:@architect"
    "ba:İş Analisti & Product Owner:@ba"
    "backend:Kıdemli Backend Uzmanı:@backend"
    "db:Veritabanı ve ORM Uzmanı:@db"
    "realtime:Gerçek Zamanlı Sistemler ve Worker Uzmanı:@realtime"
    "frontend:Kıdemli Web Frontend Uzmanı:@frontend"
    "mobile:Cross-Platform Mobil Uzmanı:@mobile"
    "uiux:UI/UX Tasarım ve Ergonomi Uzmanı:@uiux"
    "security:Siber Güvenlik & AppSec Uzmanı:@security"
    "devops:DevOps, Linux ve CI/CD Uzmanı:@devops"
    "qa:Kalite Güvence ve Test Uzmanı:@qa"
    "refactor:Clean Code ve Performans Uzmanı:@refactor"
    "docs:Teknik Yazar ve Dokümantasyon Uzmanı:@docs"
    "legal:Bilişim Hukuku ve Lisans Uzmanı:@legal"
)

TEMPLATE_SKILL="$OLAF_CENTRAL_DIR/templates/learned-skill-template.md"
CURRENT_DATE="$(date '+%Y-%m-%d %H:%M:%S')"

for item in "${AGENTS_LIST[@]}"; do
    IFS=":" read -r key role tag <<< "$item"
    SKILL_FILE="$TARGET_DIR/.olaf/learned-skills/${key}-skills.md"
    
    if [ ! -f "$SKILL_FILE" ]; then
        if [ -f "$TEMPLATE_SKILL" ]; then
            KEY_UPPER=$(echo "$key" | tr '[:lower:]' '[:upper:]')
            sed -e "s|{{AGENT_NAME}}|${KEY_UPPER} AGENT|g" \
                -e "s|{{AGENT_ROLE}}|$role|g" \
                -e "s|{{AGENT_TAG}}|$tag|g" \
                -e "s|{{LAST_UPDATED}}|$CURRENT_DATE|g" \
                -e "s|{{TRAINING_STATUS}}|EĞİTİM BEKLİYOR|g" \
                "$TEMPLATE_SKILL" > "$SKILL_FILE"
        fi
    fi
done

# 4. ACTIVE SPRINT VE PROJECT BRAIN DOSYALARINI BAŞLAT
if [ ! -f "$TARGET_DIR/.olaf/memory/active-sprint.md" ]; then
    TEMPLATE_SPRINT="$OLAF_CENTRAL_DIR/templates/active-sprint-template.md"
    if [ -f "$TEMPLATE_SPRINT" ]; then
        sed -e "s|{{SPRINT_TITLE}}|Sprint 01 - Proje Kurulumu ve Başlangıç|g" \
            -e "s|{{SPRINT_START_DATE}}|$CURRENT_DATE|g" \
            -e "s|{{SPRINT_GOAL}}|Projenin analizi, mimari temelleri ve ilk sürüm hedefleri|g" \
            "$TEMPLATE_SPRINT" > "$TARGET_DIR/.olaf/memory/active-sprint.md"
    fi
fi

# 5. PROJE TÜRÜNÜ TESPİT ET (BROWNFIELD / GREENFIELD)
echo -e "\n${COLOR_BLUE}🔍 Proje Röntgeni Çekiliyor ve Kod Taraması Yapılıyor...${COLOR_RESET}"

SRC_COUNT=$(find . -maxdepth 10 -type f \( \
    -name "*.cs" -o -name "*.java" -o -name "*.kt" -o -name "*.kts" -o \
    -name "*.dart" -o -name "*.swift" -o -name "*.ts" -o -name "*.tsx" -o \
    -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.go" -o \
    -name "*.rs" -o -name "*.php" -o -name "*.cpp" -o -name "*.c" -o \
    -name "*.vue" -o -name "*.svelte" -o -name "package.json" -o \
    -name "pom.xml" -o -name "*.csproj" -o -name "*.sln" -o \
    -name "build.gradle" -o -name "build.gradle.kts" -o -name "AndroidManifest.xml" -o \
    -name "pubspec.yaml" -o -name "Cargo.toml" -o -name "go.mod" -o -name "requirements.txt" \
\) ! -path "*/.olaf/*" ! -path "*/.git/*" ! -path "*/node_modules/*" ! -path "*/bin/*" ! -path "*/obj/*" ! -path "*/build/*" ! -path "*/.gradle/*" 2>/dev/null | wc -l)

IS_BROWNFIELD=false
if [ "$SRC_COUNT" -gt 0 ]; then
    IS_BROWNFIELD=true
fi

# 6. RÖNTGEN ANALİZİ VE PROJECT BRAIN DOLDURMA
DETECTED_STACK=""
DETECTED_FILES=""

if [ "$IS_BROWNFIELD" = true ]; then
    PROJECT_TYPE="BROWNFIELD (Mevcut Kod Tabanı)"
    TRAINING_STATUS="EĞİTİM GEREKLİ (/olaf-train çalıştırılmalı)"
    echo -e "${COLOR_YELLOW}⚡ Proje Türü:${COLOR_RESET} $PROJECT_TYPE ($SRC_COUNT kaynak dosya/paket tespit edildi)"
    
    # Bayrak dosyasını oluştur
    echo "Bu projede mevcut kaynak kodlar tespit edildi. Lütfen /olaf-train komutunu çalıştırarak 15 ajanı eğitin." > "$TARGET_DIR/.olaf/memory/TRAINING_REQUIRED.flag"
    
    # Derin Röntgen Bilgilerini Topla
    echo -e "${COLOR_BLUE}📋 Paket ve Teknoloji Analizi Yapılıyor...${COLOR_RESET}"
    
    # Android (Kotlin / Java / Gradle)
    if [ -d "android" ] || [ -f "app/build.gradle" ] || [ -f "android/app/build.gradle" ] || find . -maxdepth 5 -name "AndroidManifest.xml" 2>/dev/null | grep -q .; then
        if find . -maxdepth 8 -name "*.kt" 2>/dev/null | grep -q .; then
            DETECTED_STACK+="- Mobil: Android Projesi tespit edildi (Kotlin (Android Native))."$'\n'
        else
            DETECTED_STACK+="- Mobil: Android Projesi tespit edildi (Java (Android Native))."$'\n'
        fi
        DETECTED_STACK+="  * Gradle derleme altyapısı ve Android manifest mevcut."$'\n'
    fi

    # Flutter
    if [ -f "pubspec.yaml" ]; then
        DETECTED_STACK+="- Mobil/Cross-Platform: Flutter projesi tespit edildi (pubspec.yaml)."$'\n'
    fi

    # iOS
    if [ -f "Podfile" ] || ls *.xcodeproj 1> /dev/null 2>&1; then
        DETECTED_STACK+="- Mobil: iOS Projesi tespit edildi (Xcode / CocoaPods)."$'\n'
    fi

    # .NET / C#
    if ls *.sln 1> /dev/null 2>&1 || ls *.csproj 1> /dev/null 2>&1 || find . -maxdepth 4 -name "*.csproj" 2>/dev/null | grep -q .; then
        DETECTED_STACK+="- Backend: .NET / C# tespit edildi."$'\n'
        CSPROJ_FILES=$(find . -maxdepth 4 -name "*.csproj" 2>/dev/null | head -n 5)
        for csproj in $CSPROJ_FILES; do
            DETECTED_STACK+="  * Proje: $csproj"$'\n'
        done
    fi
    
    # Node / Web / Mobil
    if [ -f "package.json" ]; then
        DETECTED_STACK+="- JavaScript/TypeScript Ekosistemi tespit edildi (package.json)."$'\n'
        if grep -q "react-native" package.json 2>/dev/null || grep -q "expo" package.json 2>/dev/null; then
            DETECTED_STACK+="  * Mobil: React Native / Expo tespit edildi."$'\n'
        fi
        if grep -q "react" package.json 2>/dev/null; then
            DETECTED_STACK+="  * Web: React tespit edildi."$'\n'
        elif grep -q "@angular" package.json 2>/dev/null; then
            DETECTED_STACK+="  * Web: Angular tespit edildi."$'\n'
        elif grep -q "vue" package.json 2>/dev/null; then
            DETECTED_STACK+="  * Web: Vue.js tespit edildi."$'\n'
        fi
    fi
    
    # Java
    if [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
        DETECTED_STACK+="- Java Ekosistemi tespit edildi (Maven/Gradle)."$'\n'
    fi
    
    # Python
    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        DETECTED_STACK+="- Python Ekosistemi tespit edildi."$'\n'
    fi

    # Go
    if [ -f "go.mod" ]; then
        DETECTED_STACK+="- Backend: Go Ekosistemi tespit edildi (go.mod)."$'\n'
    fi

    # Rust
    if [ -f "Cargo.toml" ]; then
        DETECTED_STACK+="- Sistem/Backend: Rust Ekosistemi tespit edildi (Cargo.toml)."$'\n'
    fi

    # PHP
    if [ -f "composer.json" ]; then
        DETECTED_STACK+="- Web/Backend: PHP Ekosistemi tespit edildi (composer.json)."$'\n'
    fi
    
    # Docker
    if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ]; then
        DETECTED_STACK+="- DevOps: Docker / Docker Compose mevcut."$'\n'
    fi
    
    # GitHub Actions
    if [ -d ".github/workflows" ]; then
        DETECTED_STACK+="- CI/CD: GitHub Actions iş akışları mevcut."$'\n'
    fi

    # Klasör Ağacı Özeti (node_modules, .git hariç)
    TREE_SUMMARY=$(find . -maxdepth 2 -not -path '*/.*' -not -path './node_modules*' -not -path './bin*' -not -path './obj*' | sort | head -n 35)

else
    PROJECT_TYPE="GREENFIELD (Sıfırdan Proje)"
    TRAINING_STATUS="HAZIR (Sıfırdan Mimari Başlatılabilir)"
    echo -e "${COLOR_GREEN}🌱 Proje Türü:${COLOR_RESET} $PROJECT_TYPE (Boş proje dizini)"
    rm -f "$TARGET_DIR/.olaf/memory/TRAINING_REQUIRED.flag"
    DETECTED_STACK="Henüz kod eklenmedi. Sıfırdan mimari kurgusu için @pm hazır bekliyor."
    TREE_SUMMARY="."
fi

# project-brain.md dosyasını şablondan doldur
TEMPLATE_BRAIN="$OLAF_CENTRAL_DIR/templates/project-brain-template.md"
if [ -f "$TEMPLATE_BRAIN" ]; then
    sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{PROJECT_TYPE}}|$PROJECT_TYPE|g" \
        -e "s|{{CREATED_AT}}|$CURRENT_DATE|g" \
        -e "s|{{LAST_UPDATED}}|$CURRENT_DATE|g" \
        -e "s|{{TRAINING_STATUS}}|$TRAINING_STATUS|g" \
        -e "s|{{PROJECT_GOAL}}|$PROJECT_NAME projesinin hedefleri ve isterleri|g" \
        -e "s|{{TARGET_AUDIENCE}}|Kullanıcılar ve Sistem İstemcileri|g" \
        "$TEMPLATE_BRAIN" > "$TARGET_DIR/.olaf/memory/project-brain.md"
        
    # Tespit edilen bilgileri ekle
    cat << EOF >> "$TARGET_DIR/.olaf/memory/project-brain.md"

### 🔎 OLAF-INIT İLK RÖNTGEN BULGULARI:
$DETECTED_STACK

### 📁 TESPİT EDİLEN KLASÖR AĞACI:
\`\`\`text
$TREE_SUMMARY
\`\`\`
EOF
fi

# 7. ANTIGRAVITY VE VS CODE WORKFLOW KÖPRÜLERİNİ KUR
echo -e "\n${COLOR_BLUE}🌉 Antigravity & IDE Slash Workflows (.agent/workflows) Kuruluyor...${COLOR_RESET}"
mkdir -p "$TARGET_DIR/.agent/workflows"

cp -f "$OLAF_CENTRAL_DIR/workflows/olaf-train.md" "$TARGET_DIR/.agent/workflows/olaf-train.md"
cp -f "$OLAF_CENTRAL_DIR/workflows/pm.md" "$TARGET_DIR/.agent/workflows/pm.md"
cp -f "$OLAF_CENTRAL_DIR/workflows/sync-skills.md" "$TARGET_DIR/.agent/workflows/sync-skills.md"
cp -f "$OLAF_CENTRAL_DIR/workflows/review-all.md" "$TARGET_DIR/.agent/workflows/review-all.md"

# 8. ÇOKLU IDE MASTER KURAL KÖPRÜLERİNİ OLUŞTUR
echo -e "${COLOR_BLUE}📜 Çoklu IDE Kural Köprüleri (GEMINI.md, AGENTS.md, .cursorrules vb.) Oluşturuluyor...${COLOR_RESET}"

MASTER_RULES_CONTENT=$(cat << 'EOF'
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
EOF
)

# Kök dizine ve IDE hedef dizinlerine yaz
echo "$MASTER_RULES_CONTENT" > "$TARGET_DIR/GEMINI.md"
cp -f "$TARGET_DIR/GEMINI.md" "$TARGET_DIR/AGENTS.md"

mkdir -p "$TARGET_DIR/.idx"
cp -f "$TARGET_DIR/GEMINI.md" "$TARGET_DIR/.idx/airules.md"

mkdir -p "$TARGET_DIR/.gemini"
cp -f "$TARGET_DIR/GEMINI.md" "$TARGET_DIR/.gemini/styleguide.md"

mkdir -p "$TARGET_DIR/.github"
cp -f "$TARGET_DIR/GEMINI.md" "$TARGET_DIR/.github/copilot-instructions.md"

cp -f "$TARGET_DIR/GEMINI.md" "$TARGET_DIR/.cursorrules"
cp -f "$TARGET_DIR/GEMINI.md" "$TARGET_DIR/.clinerules"

# 9. VS CODE TASKS ENTEGRASYONU
mkdir -p "$TARGET_DIR/.vscode"
cat << 'EOF' > "$TARGET_DIR/.vscode/tasks.json"
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
EOF

# 10. GİT POST-COMMIT HOOK ENTEGRASYONU
if [ -d "$TARGET_DIR/.git" ]; then
    echo -e "${COLOR_BLUE}🔗 Git Post-Commit Hook Entegre Ediliyor...${COLOR_RESET}"
    mkdir -p "$TARGET_DIR/.git/hooks"
    HOOK_FILE="$TARGET_DIR/.git/hooks/post-commit"
    
    cat << 'EOF' > "$HOOK_FILE"
#!/usr/bin/env bash
# AI Olaf Team Git Post-Commit Güncelleyici
if [ -f ".olaf/memory/project-brain.md" ]; then
    LAST_HASH=$(git log -1 --format="%h" 2>/dev/null)
    LAST_MSG=$(git log -1 --format="%s" 2>/dev/null)
    LAST_DATE=$(git log -1 --format="%cd" --date=format:'%Y-%m-%d %H:%M:%S' 2>/dev/null)
    
    # Geçici dosyaya yazıp project-brain içine güncelle (macOS ve Linux uyumlu)
    sed -e "s/Son Commit ID:.*/Son Commit ID: $LAST_HASH/g" \
        -e "s/Son Commit Mesajı:.*/Son Commit Mesajı: $LAST_MSG/g" \
        -e "s/Son Değişiklik Tarihi:.*/Son Değişiklik Tarihi: $LAST_DATE/g" \
        .olaf/memory/project-brain.md > .olaf/memory/project-brain.tmp 2>/dev/null && \
        mv .olaf/memory/project-brain.tmp .olaf/memory/project-brain.md 2>/dev/null || true
fi
EOF
    chmod +x "$HOOK_FILE"
fi

# 11. BAŞARI RAPORU VE KULLANICI BİLGİLENDİRMESİ
echo -e "\n${COLOR_GREEN}${COLOR_BOLD}=========================================================================="
echo "    🎉 AI OLAF TEAM BAŞARIYLA ENTEGRE EDİLDİ!                            "
echo -e "==========================================================================${COLOR_RESET}"
echo -e "📁 Proje Adı       : ${COLOR_CYAN}$PROJECT_NAME${COLOR_RESET}"
echo -e "🏷️  Proje Türü      : ${COLOR_YELLOW}$PROJECT_TYPE${COLOR_RESET}"
echo -e "👥 Hazır Ajanlar   : ${COLOR_GREEN}15 Uzman Ajan (.olaf/base-agents & learned-skills)${COLOR_RESET}"
echo -e "🌉 Kurulan Köprüler: ${COLOR_CYAN}Antigravity (.agent/workflows), VS Code, Cursor, Copilot${COLOR_RESET}"

if [ "$IS_BROWNFIELD" = true ]; then
    echo -e "\n${COLOR_YELLOW}${COLOR_BOLD}👉 SIRADAKİ ADIM (ÖNEMLİ):${COLOR_RESET}"
    echo -e "Projenizde mevcut kodlar tespit edildi! Lütfen Antigravity veya VS Code sohbetinde:"
    echo -e "   ${COLOR_CYAN}${COLOR_BOLD}/olaf-train${COLOR_RESET}"
    echo -e "komutunu çalıştırarak 15 kişilik ekibin projeyi öğrenmesini sağlayın."
else
    echo -e "\n${COLOR_GREEN}${COLOR_BOLD}👉 SIRADAKİ ADIM:${COLOR_RESET}"
    echo -e "Sıfırdan proje geliştirme hazır! Antigravity veya VS Code sohbetinde:"
    echo -e "   ${COLOR_CYAN}${COLOR_BOLD}/pm [yapmak istediğiniz proje veya özellik]${COLOR_RESET}"
    echo -e "yazarak ekibi hemen yönetmeye başlayabilirsiniz."
fi
echo ""
