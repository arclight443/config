{ options, config, lib, pkgs, ... }:

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

        # Wlroots-specific
        swww
        brightnessctl
        grim
        slurp
        wl-clipboard

        # Rofi
        rofi
        rofi-bluetooth
        pkgs.arclight.rofi-wifi-menu

        # Apps
        gnome.gnome-calendar
        gnome.eog
        pavucontrol

      ];

      programs.waybar = {
        enable = true;
      };

      xdg.configFile = {
        "waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
        "rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/rofi";
      };

  };
}