{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.gtk;
in
{
  options.arclight.desktop.utils.gtk = with types; {
    enable = mkBoolOpt false "Whether or not to enable gtk theme.";

  };

  config = mkIf cfg.enable {

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      gtk4
    ];

    arclight.home.extraOptions = {

      home.sessionVariables = {
        GTK_THEME = "Gruvbox-Dark-BL-LB";
      };

      gtk = {
        enable = true;

        theme = {
          name = "Adwaita-dark";
        };

        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.arclight.gruvbox-plus;
        };

        cursorTheme = {
          name = "capitaine-cursors";
          package = pkgs.capitaine-cursors;
        };

        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
      };
    };

  };
}
