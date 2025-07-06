# Wallpaper Switcher for Hyprland with swww

This script automatically changes your wallpaper based on the time of day, supporting multiple monitors managed by Hyprland and using the `swww` wallpaper setter.

---

## Features

- Automatically sets different wallpapers for night, morning, and afternoon.
- Supports laptop and multiple external monitors by matching monitor models.
- Uses a configurable `config.ini` for easy customization.
- Starts `swww` daemon automatically if not already running.
- Periodically updates wallpaper every configurable interval.

---

## Requirements

- [Hyprland](https://github.com/hyprwm/Hyprland) window manager
- [`swww`](https://github.com/LGFae/swww) wallpaper setter installed and in your `$PATH`
- `hyprctl` command available (part of Hyprland)
- Bash shell

---

## Installation

1. Clone or download this repository (or just the script and config files).

2. Create configuration directory and file:

   ```bash
   mkdir -p ~/.config/wallpaper_switcher


3. Copy config.ini to ~/.config/wallpaper_switcher/
   Adjust paths, filenames, monitor models, and interval as needed.

4. Save the script as set_wallpaper.sh somewhere, e.g. ~/.local/bin/set_wallpaper.sh

5. Make it executable:
    ```bash
   chmod +x ~/.local/bin/set_wallpaper.sh


6. Add to your hyprland.conf to run on startup:
    ```bash
   exec-once = ~/.local/bin/set_wallpaper.sh


## Usage

Run the script manually or let Hyprland start it on launch. It will:

  Start the swww daemon if it’s not already running.

  Set the appropriate wallpaper on your laptop and external monitors.

  Refresh wallpapers every check_interval seconds.

How it works

  The script reads your config file for wallpaper paths, monitor models, and settings.

  It uses hyprctl to find connected monitors matching your external monitor models.

  Wallpapers are applied with swww img on each monitor.

  Wallpapers change depending on the current hour:

  Night: 22:00–06:00

  Morning: 06:00–13:00

  Afternoon: 13:00–22:00

Troubleshooting

  Ensure swww is installed and in your PATH.

  Check monitor model names exactly as they appear in hyprctl monitors.

  Confirm your wallpaper paths and filenames are correct.

  Run swww daemon manually if the script has issues starting it.

Enjoy your dynamic wallpapers with Hyprland and swww!
If you want improvements or features, feel free to open issues or PRs.
