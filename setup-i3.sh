#!/usr/bin/env bash

# Caminho do script atual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

progress_echo() {
  local text="$1"
  for i in {1..3}; do
    echo -ne "\r$text$(printf ' %.0s' $(seq 1 $i))"
    sleep 0.5
  done
  echo ""
}

# ============================
# 🔄 Atualizando sistema
# ============================
progress_echo "📦 Atualizando o sistema"
sudo pacman -Syu --noconfirm
echo "✅ Concluído!"
sleep 1
echo

# ============================
# 🖥️ Xorg e ambiente gráfico
# ============================
progress_echo "🧱 Instalando Xorg + xinit"
sudo pacman -S --needed --noconfirm xorg xorg-xinit
echo "✅ Concluído!"
sleep 1
echo

# ============================
# 🔊 PipeWire + codecs
# ============================
progress_echo "🎵 Instalando PipeWire e codecs"
sudo pacman -S --needed --noconfirm \
  pipewire pipewire-pulse \
  gstreamer gst-libav \
  gst-plugins-base gst-plugins-good \
  gst-plugins-bad gst-plugins-ugly \
  ffmpeg
echo "✅ Concluído!"
sleep 1
echo

# Ativando PipeWire no usuário
systemctl --user enable pipewire pipewire-pulse

# Verifica se o usuário tem "linger" ativado
if loginctl show-user "$USER" | grep -q 'Linger=no'; then
  echo -e "\n⚠️  PipeWire pode não iniciar automaticamente após logout/reboot."
  echo "   ➤ Considere executar:  loginctl enable-linger $USER"
fi

sleep 1
echo

# ============================
# 🛠️ Utilitários e sistema
# ============================
progress_echo "📂 Instalando utilitários do sistema"
sudo pacman -S --needed --noconfirm \
  gufw xfce4-terminal git wget curl which \
  nemo loupe fzf ranger brightnessctl flameshot \
  xdg-user-dirs-gtk xdg-utils \
  adwaita-icon-theme papirus-icon-theme \
  ttf-roboto ttf-opensans ttf-dejavu \
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
echo "✅ Concluído!"
sleep 1
echo

# ============================
# 🎛️ i3WM e ferramentas
# ============================
progress_echo "🧱 Instalando i3WM e componentes"
sudo pacman -S --needed --noconfirm \
  i3-wm i3blocks i3lock lightdm lightdm-gtk-greeter \
  xorg-xset sysstat lm_sensors xsettingsd \
  networkmanager-openvpn nm-connection-editor \
  pavucontrol alsa-utils pamixer playerctl \
  power-profiles-daemon xfce4-power-manager acpi \
  polkit-gnome dex rofi xfce4-terminal \
  scrot imagemagick libnotify \
  lxappearance nitrogen arandr
echo "✅ Concluído!"
sleep 1
echo

# ============================
# 🔧 Ativando serviços
# ============================
echo "🛠️ Ativando serviços essenciais..."
sudo systemctl enable lightdm
echo "✅ LightDM ativado!"
sleep 1
echo

# ============================
# 🗂️ Copiando configs i3 e rofi
# ============================
progress_echo "📁 Copiando arquivos de configuração do i3 e rofi"
cp -rv "$SCRIPT_DIR/i3" ~/.config/
cp -rv "$SCRIPT_DIR/rofi" ~/.config/

# Permissões de execução
chmod +x "$HOME/.config/i3/scripts/"* 2>/dev/null || true
echo "✅ Configurações aplicadas!"
sleep 1
echo

# ============================
# 🏁 Finalização
# ============================
echo -e "\n✅ Tudo instalado com sucesso!"
echo "🚀 Reinicie o sistema para iniciar no i3WM!"
