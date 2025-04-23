#!/usr/bin/env bash

echo -e "\n▶️ Iniciando script de pós-instalação...\n"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

progress_echo() {
  local text="$1"
  for i in {1..3}; do
    echo -ne "\r$text$(printf ' %.0s' $(seq 1 $i))"
    sleep 0.4
  done
  echo ""
}

# ===============================
# 🔧 Instala yay
# ===============================
if ! command -v yay &> /dev/null; then
  progress_echo "⏬ Instalando yay (AUR helper)"
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay || exit
  makepkg -si --noconfirm
  cd - || exit
else
  echo "✅ yay já está instalado!"
fi
echo
sleep 1

# ===============================
# 📦 Instala pacotes com yay
# ===============================
progress_echo "📦 Instalando ferramentas via yay"
yay -S --noconfirm wezterm zsh eza bat asdf tmux
echo "✅ Concluído!"
echo
sleep 1

# ===============================
# ⚙️ oh-my-zsh
# ===============================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  progress_echo "⚙️ Instalando oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "✅ oh-my-zsh instalado!"
else
  echo "✅ oh-my-zsh já está instalado!"
fi
sleep 1

# ===============================
# 🚀 Instala Starship Prompt
# ===============================
if ! command -v starship &> /dev/null; then
  progress_echo "🚀 Instalando Starship Prompt"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  echo "✅ Starship instalado e configurado!"
else
  echo "✅ Starship já está instalado!"
fi
sleep 1

# ===============================
# 🧩 Plugins do zsh
# ===============================
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
echo "✅ Plugins do zsh prontos!"
sleep 1

# ===============================
# 🐚 zsh como shell padrão
# ===============================
chsh -s "$(which zsh)"
echo "✅ zsh definido como shell padrão!"
sleep 1

# ===============================
# 🗂️ Copiando arquivos de configuração
# ===============================
progress_echo "🗂️ Copiando dotfiles..."
mkdir -p ~/.config/wezterm/
cp "$SCRIPT_DIR/.wezterm.lua" ~/.config/wezterm/wezterm.lua
cp "$SCRIPT_DIR/.zshrc" ~/
cp "$SCRIPT_DIR/.tmux.conf" ~/
echo "✅ Dotfiles copiados!"
echo
sleep 1

# ===============================
# 🔌 TPM (Tmux Plugin Manager)
# ===============================
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  progress_echo "📦 Instalando TPM (Tmux Plugin Manager)"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "✅ TPM instalado!"
else
  echo "✅ TPM já existe!"
fi
sleep 1

# ===============================
# 🐍 Instala pyenv
# ===============================
if ! command -v pyenv &> /dev/null; then
  progress_echo "🐍 Instalando pyenv"
  curl -fsSL https://pyenv.run | bash
  echo "✅ pyenv instalado!"
else
  echo "✅ pyenv já está no sistema!"
fi
sleep 1

# ===============================
# 🟢 Instala NVM
# ===============================
if [ ! -d "$HOME/.nvm" ]; then
  progress_echo "🟢 Instalando NVM"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
  echo "✅ NVM instalado!"
else
  echo "✅ NVM já está instalado!"
fi
sleep 1

# ===============================
# 🏁 Finalização
# ===============================
echo -e "\n🎉 Pós-instalação finalizada com sucesso!"
echo "🔁 Você pode reiniciar ou abrir um novo terminal para ver tudo funcionando."
