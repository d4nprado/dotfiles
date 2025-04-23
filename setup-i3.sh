#!/usr/bin/env bash

echo "📦 Atualizando o sistema..."
sudo pacman -Syu --noconfirm

# ====================================
# 🖥️ Xorg e ambiente gráfico básico
# ====================================
echo "🧱 Instalando Xorg + xinit..."
sudo pacman -S --needed --noconfirm xorg xorg-xinit

# ====================================
# 🔊 Multimídia + PipeWire
# ====================================
echo "🎵 Instalando PipeWire e codecs..."
sudo pacman -S --needed --noconfirm \
  pipewire pipewire-pulse \
  gstreamer gst-libav \
  gst-plugins-base gst-plugins-good \
  gst-plugins-bad gst-plugins-ugly \
  ffmpeg

# Ativando PipeWire no usuário
systemctl --user enable pipewire pipewire-pulse

# ====================================
# 🛠️ Utilitários e apps do sistema
# ====================================
echo "📂 Instalando utilitários gerais..."
sudo pacman -S --needed --noconfirm \
  gufw xfce4-terminal git wget curl which \
  nemo loupe fzf ranger \
  xdg-user-dirs-gtk xdg-utils \
  adwaita-icon-theme papirus-icon-theme \
  ttf-roboto ttf-opensans ttf-dejavu \
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols

# ====================================
# 🎛️ i3WM e ferramentas
# ====================================
echo "🧱 Instalando i3WM e componentes..."
sudo pacman -S --needed --noconfirm \
  i3-wm i3blocks i3lock lightdm lightdm-gtk-greeter \
  xorg-xset sysstat lm_sensors \
  networkmanager-openvpn nm-connection-editor \
  pavucontrol alsa-utils pamixer playerctl \
  power-profiles-daemon xfce4-power-manager acpi \
  polkit-gnome dex rofi xfce4-terminal \
  scrot imagemagick libnotify \
  lxappearance nitrogen arandr

# ====================================
# ⚙️ Habilitando serviços
# ====================================
echo "🛠️ Ativando serviços essenciais..."
sudo systemctl enable lightdm

echo "📁 Copiando arquivos de configuração do i3 e rofi..."
cp -r ./config ~/.config

# Garante que todos os scripts tenham permissão de execução
chmod +x ~/.config/i3/scripts/* || true

# ====================================
# ✅ Finalização
# ====================================
echo -e "\n✅ Tudo instalado com sucesso!"
echo "🔁 Agora reinicie o sistema para iniciar no i3WM!"
