{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.alacritty;

in
{
  options.arclight.desktop.utils.alacritty = with types; {
    enable = mkBoolOpt false "Whether or not to enable alacritty";
  };

  config = mkIf cfg.enable {
    arclight.system.env = {
      "XCURSOR_THEME" = lib.concatStringsSep " " [ config.arclight.home.extraOptions.gtk.cursorTheme.name "alacritty" ];
    };
    arclight.home.extraOptions = {
      programs.alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.7;

          font = {
            normal.family = "MesloLGS NF";
            size = 13.5;
          };

          padding.x = 4;
          padding.y = 4;

          colors = {

            primary = {
              background = "0x1d2021";
              foreground = "0xd4be98";
            };

            normal = {
              black = "0x1D2021";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              aqua = "0x89b482";
              white = "0xd4be98";
            };

            bright = {
              black = "0x17191a";
              red = "0xea6962";
              green = "0xa9b665";
              yellow = "0xd8a657";
              blue = "0x7daea3";
              magenta = "0xd3869b";
              aqua = "0x89b482";
              white = "0xd4be98";
            };

          };
        };
      };

    };
  };
}
