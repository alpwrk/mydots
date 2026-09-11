#!/bin/bash
# Battery output for the waybar custom/batstats module.
# Prints icon + percentage in one line, e.g. "󰂄 85%".
# Reason this exists instead of the built-in battery module: the built-in
# can't tell "plugged in and full" from "charging", and on some machines
# BAT0/status stays empty while on AC.

BAT_PATH="/sys/class/power_supply/BAT0"

# Desktops and VMs have no battery at all
if [ ! -d "$BAT_PATH" ]; then
    echo "[BAT N/A]"
    exit 0
fi

CAP=$(cat "$BAT_PATH/capacity" 2>/dev/null)
# AC state fills in for devices where BAT0/status is not readable
AC_ONLINE=$(cat /sys/class/power_supply/AC/online 2>/dev/null)
STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)

if [ -z "$STATUS" ] && [ "$AC_ONLINE" = "1" ]; then
    STATUS="Charging"
fi

if [ -z "$CAP" ]; then
    echo "[BAT N/A]"
    exit 0
fi

if [ "$STATUS" = "Charging" ]; then
    echo "󰂄 ${CAP}%"
elif [ "$AC_ONLINE" = "1" ]; then
    # Plugged in but not charging = full
    echo "󰂅 ${CAP}%"
else
    # Discharging: pick from the 10-step battery icons by tens digit.
    # 100% would overflow the index, so clamp to the last one.
    ICONS=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
    IDX=$((CAP / 10))
    if [ "$IDX" -gt 9 ]; then
        IDX=9
    fi
    echo "${ICONS[$IDX]} ${CAP}%"
fi