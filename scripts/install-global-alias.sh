#!/usr/bin/env bash
# ==============================================================================
# AI OLAF TEAM - GLOBAL ALIAS VE ÇALIŞTIRMA KURULUM BETİĞİ
# ==============================================================================
# Bu betik, 'olaf-init' komutunu sistem genelinde (~/.local/bin, ~/.bashrc ve
# ~/.zshrc) tanımlayarak herhangi bir klasörden tek kelimeyle çağrılmasını sağlar.
# ==============================================================================

set -e

COLOR_RESET="\033[0m"
COLOR_BOLD="\033[1m"
COLOR_CYAN="\033[36m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"

echo -e "${COLOR_CYAN}${COLOR_BOLD}"
echo "=========================================================================="
echo "    🔗 AI OLAF TEAM - GLOBAL KOMUT KURULUM SİHİRBAZI                     "
echo "=========================================================================="
echo -e "${COLOR_RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${COLOR_GREEN}✓ AI Olaf Team Repo Yolu:${COLOR_RESET} $REPO_DIR"

# 1. ~/.local/bin İÇİNE ÇALIŞTIRILABİLİR WRAPPER OLUŞTUR
mkdir -p "$HOME/.local/bin"
WRAPPER_PATH="$HOME/.local/bin/olaf-init"

cat << EOF > "$WRAPPER_PATH"
#!/usr/bin/env bash
export AI_OLAF_TEAM_DIR="$REPO_DIR"
exec bash "$REPO_DIR/scripts/olaf-init.sh" "\$@"
EOF

chmod +x "$WRAPPER_PATH"
echo -e "${COLOR_GREEN}✓ Doğrudan Çalıştırıcı Oluşturuldu:${COLOR_RESET} $WRAPPER_PATH"

# 2. SHELL PROFİLLERİNE (BASH & ZSH) ALIAS VE ORTAM DEĞİŞKENİ EKLE
CONFIG_SNIPPET=$(cat << EOF

# >>> AI OLAF TEAM GLOBAL INTEGRATION >>>
export AI_OLAF_TEAM_DIR="$REPO_DIR"
export PATH="\$HOME/.local/bin:\$PATH"
alias olaf-init="bash \$AI_OLAF_TEAM_DIR/scripts/olaf-init.sh"
# <<< AI OLAF TEAM GLOBAL INTEGRATION <<<
EOF
)

# Profil dosyalarının varlığını garantiye al (macOS / Linux uyumluluğu)
if [ ! -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
    if [ "$(uname -s)" = "Darwin" ] || [ "$SHELL" = "*/zsh" ]; then
        touch "$HOME/.zshrc"
    else
        touch "$HOME/.bashrc"
    fi
fi

# ~/.bashrc Kontrolü
if [ -f "$HOME/.bashrc" ]; then
    if grep -q "AI OLAF TEAM GLOBAL INTEGRATION" "$HOME/.bashrc"; then
        echo -e "${COLOR_YELLOW}✓ ~/.bashrc içinde zaten tanımlı, güncellenmedi.${COLOR_RESET}"
    else
        echo "$CONFIG_SNIPPET" >> "$HOME/.bashrc"
        echo -e "${COLOR_GREEN}✓ ~/.bashrc dosyasına olaf-init alias ve PATH eklendi.${COLOR_RESET}"
    fi
fi

# ~/.zshrc Kontrolü (macOS varsayılan kabuğu Zsh)
if [ -f "$HOME/.zshrc" ]; then
    if grep -q "AI OLAF TEAM GLOBAL INTEGRATION" "$HOME/.zshrc"; then
        echo -e "${COLOR_YELLOW}✓ ~/.zshrc içinde zaten tanımlı, güncellenmedi.${COLOR_RESET}"
    else
        echo "$CONFIG_SNIPPET" >> "$HOME/.zshrc"
        echo -e "${COLOR_GREEN}✓ ~/.zshrc dosyasına olaf-init alias ve PATH eklendi.${COLOR_RESET}"
    fi
fi

# macOS için ~/.zprofile kontrolü (login shell desteği)
if [ "$(uname -s)" = "Darwin" ] && [ -f "$HOME/.zprofile" ]; then
    if ! grep -q "AI OLAF TEAM GLOBAL INTEGRATION" "$HOME/.zprofile"; then
        echo "$CONFIG_SNIPPET" >> "$HOME/.zprofile"
        echo -e "${COLOR_GREEN}✓ ~/.zprofile dosyasına olaf-init alias ve PATH eklendi.${COLOR_RESET}"
    fi
fi

echo -e "\n${COLOR_GREEN}${COLOR_BOLD}🎉 TEBRİKLER! Kurulum başarıyla tamamlandı.${COLOR_RESET}"
echo -e "\nDeğişikliklerin mevcut terminalinizde hemen geçerli olması için lütfen şu komutu çalıştırın:"
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "*/zsh" ]; then
    echo -e "   ${COLOR_CYAN}${COLOR_BOLD}source ~/.zshrc${COLOR_RESET}"
else
    echo -e "   ${COLOR_CYAN}${COLOR_BOLD}source ~/.bashrc${COLOR_RESET}"
fi
echo -e "\nArtık dilediğiniz herhangi bir proje klasörüne gidip sadece:"
echo -e "   ${COLOR_GREEN}${COLOR_BOLD}olaf-init${COLOR_RESET}"
echo -e "yazarak 15 kişilik otonom ekibi projenize anında dahil edebilirsiniz!\n"
