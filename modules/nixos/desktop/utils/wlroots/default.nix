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

        # Wlroots-specific
        swww
        brightnessctl
        grim
        slurp
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

      security.pam.services.swaylock = {};

      arclight.home.extraOptions = {

        programs.waybar = {
          enable = true;
          package = inputs.waybar.packages.${pkgs.system}.waybar;
        };

        programs.swaylock = {
          enable = true;
          package = pkgs.swaylock-effects;
        };

      };

      home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

        xdg.configFile = {
          "waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
          "swaync".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swaync";
          "rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/rofi";
          "swaylock".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swaylock";
        };

      };

  };
}
