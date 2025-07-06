#!/bin/bash

# Start swww daemon if not running
if ! pgrep -x "swww" > /dev/null; then
  swww daemon &
  sleep 1  # ge daemonen lite tid att starta
fi

# Load config
CONFIG_FILE="${HOME}/.config/wallpaper_switcher/config.ini"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

# Function to parse ini file (simple key=value)
parse_ini() {
  local key=$1
  grep -E "^$key=" "$CONFIG_FILE" | tail -n1 | cut -d'=' -f2-
}

# Read config variables
WALLPAPER_DIR=$(eval echo "$(parse_ini wallpaper_dir)")
NIGHT_IMAGE="$WALLPAPER_DIR/$(parse_ini night_image)"
MORNING_IMAGE="$WALLPAPER_DIR/$(parse_ini morning_image)"
AFTERNOON_IMAGE="$WALLPAPER_DIR/$(parse_ini afternoon_image)"
EXTERNAL_MONITOR_MODELS=$(parse_ini external_monitor_models)
LAPTOP_SCREEN=$(parse_ini laptop_screen)
CHECK_INTERVAL=$(parse_ini check_interval)

# Function to find monitor names by model list
find_monitors_by_models() {
  local IFS=',' read -ra models <<< "$EXTERNAL_MONITOR_MODELS"
  local monitors=()

  for model in "${models[@]}"; do
    while read -r monitor; do
      monitors+=("$monitor")
    done < <(hyprctl monitors | awk -v model="$model" '
      $1 == "Monitor" {monitor=$2}
      $1 == "model:" && $0 ~ model {print monitor}
    ')
  done

  printf "%s\n" "${monitors[@]}" | sort -u
}

set_wallpapers() {
  local hour=$(date +%H)
  local wallpaper=""

  if [ "$hour" -ge 22 ] || [ "$hour" -lt 6 ]; then
    wallpaper="$NIGHT_IMAGE"
  elif [ "$hour" -ge 6 ] && [ "$hour" -lt 13 ]; then
    wallpaper="$MORNING_IMAGE"
  else
    wallpaper="$AFTERNOON_IMAGE"
  fi

  swww img --outputs "$LAPTOP_SCREEN" --fill-color "#000000" "$wallpaper"

  local external_monitors
  external_monitors=$(find_monitors_by_models)

  if [ -z "$external_monitors" ]; then
    echo "No external monitors found matching models: $EXTERNAL_MONITOR_MODELS"
  else
    for monitor in $external_monitors; do
      swww img --outputs "$monitor" --fill-color "#000000" "$wallpaper"
    done
  fi
}

set_wallpapers

while true; do
  sleep "$CHECK_INTERVAL"
  set_wallpapers
done
