{ options, inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.wlroots;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.utils.wlroots = with types; {
    enable = mkBoolOpt false "Whether or not to enable components and common apps used in wlroots-based compositor.";
  };

  config = mkIf cfg.enable {

      home.packages = with pkgs;[
        # common
        pamixer
        playerctl

        # Wlroots-specific
        swww
        brightnessctl
        wl-clipboard

        # Rofi
        rofi
        rofi-bluetooth
        pkgs.arclight.rofi-wifi-menu

        # GTK utilities
        powersupply

        # Apps
        gnome.gnome-calendar
        gnome.eog
        gnome.filer-roller
        pavucontrol

      ];

      arclight.desktop.utils.wlroots = {
        waybar = enabled;
        rofi = enabled;
        swappy = enabled;
      };

  };
}
