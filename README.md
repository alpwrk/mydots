# mydots

My sway + waybar + rofi setup. Monochrome, keyboard first, no icons unless a
module prints them itself.

Copy the folders into `~/.config`:

    cp -r sway waybar rofi ~/.config/

Things worth knowing:

- The sway config uses SwayFX options (blur, shadows, corner_radius). With
  plain sway those lines are just ignored, everything else still works.
- waybar expects `batstats.sh` and `metastats.sh` next to its config, and they
  need to be executable (`chmod +x`).
- The wallpaper path in `sway/config` and the `@theme` path in `rofi/config.rasi`
  are hardcoded to my home, fix those after cloning.
- `rofi/mono.rasi` is the actual theme, `config.rasi` only points to it.

Super+D launches apps, Super+Enter opens ghostty, Super+R resizes.
Everything else is written down in the sway config itself.