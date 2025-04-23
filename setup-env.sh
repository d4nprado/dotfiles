#!/usr/bin/env bash

echo "▶️ Iniciando script de instalação..."

# Instala yay (AUR Helper)
if ! command -v yay &> /dev/null; then
  echo "⏬ Instalando yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay || exit
  makepkg -si --noconfirm
  cd - || exit
fi

# Instala ferramentas via yay
yay -S --noconfirm wezterm zsh eza bat asdf tmux

# Copia arquivos de configuração
echo "🗂️ Copiando arquivos de configuração..."
cp .wezterm.lua ~/.config/wezterm/
cp .zshrc ~/
cp .tmux.conf ~/

# Instala oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "⚙️ Instalando oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Instala plugins do zsh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Define o zsh como shell padrão
chsh -s "$(which zsh)"

# Instala TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "📦 Instalando TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Instala pyenv
if ! command -v pyenv &> /dev/null; then
  echo "🐍 Instalando pyenv..."
  curl -fsSL https://pyenv.run | bash
fi

# Instala nvm
if [ ! -d "$HOME/.nvm" ]; then
  echo "🟢 Instalando NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
fi

echo -e "\n✅ Tudo instalado com sucesso!"
echo "🔁 Agora reinicie o sistema!"
