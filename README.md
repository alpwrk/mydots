# mydots

My sway + waybar + rofi setup. Monochrome, keyboard first, no icons unless a
module prints them itself.

## Install

    git clone https://github.com/alpwrk/mydots.git
    cd mydots
    cp -r sway waybar rofi ~/.config/

That's the whole install. Nothing is wired up to a dotfile manager on
purpose, if I change something I just copy it back into the repo.

## Dependencies

Arch package names, I'm on CachyOS. Everything the configs actually call:

    paru -S swayfx waybar rofi ghostty ttf-jetbrains-mono-nerd \
             grim slurp wl-clipboard playerctl brightnessctl \
             pipewire wireplumber pavucontrol network-manager-applet \
             blueman mako polkit-kde-agent-1 dmenu

- `swayfx` - plain sway works too, but ignores the blur/shadow/corner lines
- `waybar`, `rofi`, `ghostty` - bar, launcher, terminal
- `ttf-jetbrains-mono-nerd` - the font, plus every glyph the bar prints
- `grim`, `slurp`, `wl-clipboard` - screenshots
- `playerctl`, `brightnessctl` - media and brightness keys
- `pipewire` + `wireplumber` - volume keys via wpctl
- `pavucontrol` - opens when clicking the volume module
- `network-manager-applet`, `blueman` - click targets for the tray drawer
- `mako` - notifications, the bell in the drawer toggles do-not-disturb
- `polkit-kde-agent-1` (AUR) - started at login for privilege prompts
- `dmenu` - Super+D pipes `dmenu_path` into rofi

Referenced but optional, the bindings and window rules just do nothing
without them: `flameshot`, `zen`, `opencode`, `pacman-contrib` (only for
the spare update module, which is disabled anyway).

## Things worth knowing
- waybar expects `batstats.sh` and `metastats.sh` next to its config, and they
  need to be executable (`chmod +x`).
- The wallpaper path in `sway/config` and the `@theme` path in `rofi/config.rasi`
  are hardcoded to my home, fix those after cloning.
- `rofi/mono.rasi` is the actual theme, `config.rasi` only points to it.

Super+D launches apps, Super+Enter opens ghostty, Super+R resizes.
Everything else is written down in the sway config itself.