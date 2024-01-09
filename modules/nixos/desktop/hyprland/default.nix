{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.hyprland;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

  hyprland-substituter = {
    url = "https://hyprland.cachix.org";
    key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
  };

in
{
  options.arclight.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
  };

  config = mkIf cfg.enable {
    
    environment.systemPackages = with pkgs;[
      sassc
      swww
      brightnessctl
    ];

    arclight.desktop.utils = {
      gtk = enabled;
      qt = enabled;
      dconf = enabled;
      electron-support = enabled;
      kitty = enabled;
    };

    arclight.system.xkb.enable = true;

    arclight.nix.extra-substituters = { 
      "https://hyprland.cachix.org".key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    };
    
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    arclight.home.extraOptions = {
      #wayland.windowManager.hyprland = {
      #  enable = true;
      #};
      programs.ags.enable = true;
      
      home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors";
        size = 24;
      };

    };

  };
}
