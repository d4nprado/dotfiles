#!/usr/bin/env bash
export DISPLAY=:0

SSID=$(nmcli -t -f SSID dev wifi | tail -n +2 | sed '/^--/d' | sed '/^$/d' | sort -u)

SELECTED=$(echo "$SSID" | yad --list \
    --title="Redes Wi-Fi" \
    --column="SSID" \
    --width=250 \
    --height=200 \
    --window-icon=network-wireless \
    --undecorated \
    --center \
    --on-top \
    --skip-taskbar \
    --borders=10 \
    --button="Conectar:0" \
    --button="Cancelar:1")

# Se clicou em conectar
if [ $? -eq 0 ] && [ -n "$SELECTED" ]; then
    SSID_CLEAN=$(echo "$SELECTED" | awk -F'|' '{print $1}')
    nmcli device wifi connect "$SSID_CLEAN"
fi
