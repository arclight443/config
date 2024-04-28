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

    environment.systemPackages = with pkgs;[
      # common
      playerctl

      # Wlroots-specific
      swww
      brightnessctl
      grim
      slurp
      swappy
      wl-clipboard
      wvkbd
      swayosd

      # Rofi
      rofi
      rofi-bluetooth
      pkgs.arclight.rofi-wifi-menu

      # GTK utilities
      powersupply
      swaynotificationcenter

      # Apps
      gnome.gnome-calendar
      gnome.eog
      gnome.file-roller
      pavucontrol

    ];

    arclight.desktop.utils.wlroots = {
      waybar = enabled;
      swaylock = enabled;
    };

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      xdg.configFile = {
        "swaync".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swaync";
        "rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/rofi";
        "swappy/config".text = ''
          [Default]
          save_dir=$HOME/Pictures/Screenshots
          save_filename_format=%Y-%m-%d_%H.%M.%S.png
        '';
      };

    };

  };
}
