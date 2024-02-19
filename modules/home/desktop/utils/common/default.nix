{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.common;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.utils.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities for desktop systems.";
  };

  config = mkIf cfg.enable {

    #xdg.configFile = {
    #  "mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/mimeapps.list";
    #};

    home.packages = with pkgs; [
      gnome.dconf-editor
      dconf2nix
      nixgl.auto.nixGLDefault
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

  };
}
