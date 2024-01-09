{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.alacritty;
  gnome-terminal-spoof = pkgs.writeShellScriptBin "gnome-terminal" ''
    ${pkgs.alacritty}/bin/alacritty $@
  '';

in
{
  options.arclight.desktop.utils.alacritty = with types; {
    enable = mkBoolOpt false "Whether or not to enable alacritty";
  };

  config = mkIf cfg.enable {
    arclight.system.env = {
      "XCURSOR_THEME" = lib.concatStringsSep " " [ config.home-manager.users.${config.arclight.user.name}.gtk.cursorTheme.name "alacritty" ];
    };
    arclight.home.extraOptions = {
      home.packages = [ gnome-terminal-spoof ];
      programs.alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.75;

          font = {
            normal.family = "MesloLGS NF";
            size = if config.arclight.desktop.gnome.enable then 16.5 else 11.5;
          };

          padding.x = 50;
          padding.y = 50;

          colors = {

            primary = {
              background = "#282828";
              foreground = "#d4be98";
            };

            normal = {
              black = "#3c3836";
              red = "#ea6962";
              green = "#a9b665";
              yellow = "#d8a657";
              blue = "#7daea3";
              magenta = "#d3869b";
              aqua = "#89b482";
              white = "#d4be98";
            };

            bright = {
              black = "#3c3836";
              red = "#ea6962";
              green = "#a9b665";
              yellow = "#d8a657";
              blue = "#7daea3";
              magenta = "#d3869b";
              aqua = "#89b482";
              white = "#d4be98";
            };

          };
        };
      };

    };
  };
}
