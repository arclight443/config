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

      environment.systemPackages = with pkgs;[
        
        # Wlroots-specific
        swww
        brightnessctl
        grim
        slurp
        wl-clipboard
        wvkbd

        # GTK utilities
        networkmanagerapplet
        blueman
        swaynotificationcenter
        ulauncher

        # Apps
        gnome.gnome-calendar
        gnome.eog
        pavucontrol

      ];

      security.pam.services.swaylock = {};

      arclight.home.extraOptions = {

        programs.waybar = {
          enable = true;
          #settings = {
          #  mainBar = {
          #    layer = "top";
          #    position = "top";
          #    height = 30;
          #    output = [
          #      "eDP-1"
          #    ];
          #    modules-left = [ "hyprland/workspaces" "hyprland/submap" "wlr/taskbar" ];
          #    modules-center = [ "hyprland/window" ];
          #    #modules-right = [ "mpd" ];
          #
          #    "sway/workspaces" = {
          #      disable-scroll = true;
          #      all-outputs = true;
          #    };
          #
          #  };
          #};
        };
        
        programs.swaylock = {
          enable = true;
          package = pkgs.swaylock-effects;
        };

      };

  };
}
