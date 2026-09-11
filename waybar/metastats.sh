#!/bin/bash
# Cycles through system stats for the waybar custom/metastats module.
# Scroll up/down (waybar passes "up"/"down" as $1) switches between
# CPU, MEM, LOAD, TEMP and UPTIME. State survives waybar reloads via
# a file in /tmp, which also means it resets on reboot, and that's fine.

STATE_FILE="/tmp/waybar_stack_state"
MAX=5

[ ! -f "$STATE_FILE" ] && echo 0 > "$STATE_FILE"
STATE=$(cat "$STATE_FILE")

# --- Scroll input: advance/wrap the state ---
if [ "$1" = "up" ]; then
    STATE=$(( (STATE + 1) % MAX ))
    echo "$STATE" > "$STATE_FILE"
elif [ "$1" = "down" ]; then
    STATE=$(( (STATE - 1 + MAX) % MAX ))
    echo "$STATE" > "$STATE_FILE"
fi

# --- Stats ---
CPU=$(grep 'cpu ' /proc/stat | awk '{print int(($2+$4)*100/($2+$4+$5))}')
MEM=$(free | awk '/Mem:/ {print int($3/$2*100)}')
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)
# First thermal zone that exists wins; empty when there is none
TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1)
[ -n "$TEMP" ] && TEMP=$((TEMP/1000))

# --- Uptime, formatted as 2d 3h or 4h 12m ---
UPTIME=$(awk '{print int($1)}' /proc/uptime)
DAYS=$((UPTIME/86400))
HOURS=$(( (UPTIME%86400)/3600 ))
MINS=$(( (UPTIME%3600)/60 ))

if [ "$DAYS" -gt 0 ]; then
    UPTIME_STR="${DAYS}d ${HOURS}h"
else
    UPTIME_STR="${HOURS}h ${MINS}m"
fi

# --- Output: one line for the current state ---
case "$STATE" in
    0)
        echo "[CPU $CPU%]"
        ;;
    1)
        echo "[MEM $MEM%]"
        ;;
    2)
        echo "[LOAD $LOAD]"
        ;;
    3)
        [ -n "$TEMP" ] && echo "[TEMP ${TEMP}°C]" || echo "[TEMP N/A]"
        ;;
    4)
        echo "[UP $UPTIME_STR]"
        ;;
esac