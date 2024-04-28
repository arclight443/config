{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.common;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";
  nix-wallpaper = import ./wallpaper.nix { inherit config pkgs lib inputs; };

in
{
  options.arclight.desktop.utils.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities for desktop systems.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      gnome.dconf-editor
      dconf2nix
    ];

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      #xdg.configFile = {
      #  "mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/mimeapps.list";
      #};

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      home.file = lib.mapAttrs' (name: pkg: {
        name = "Pictures/wallpaper/wallpaper-${name}.png";
        value = {
          source = "${pkg}/share/wallpapers/nixos-wallpaper.png";
          target = "Pictures/Wallpapers/nixos-wallpaper-${name}.png";
        };
      }) nix-wallpaper;

    };

  };
}
