{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.gtk;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.utils.gtk = with types; {
    enable = mkBoolOpt false "Whether or not to enable gtk theme.";

  };

  config = mkIf cfg.enable {

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      gtk4
      gradience
    ];

    services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      xdg.configFile = {
        "gtk-4.0/gtk.css".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/gtk-4.0/gtk.css";
        "gtk-3.0/gtk.css".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/gtk-4.0/gtk.css";
      };

    };

    arclight.home.extraOptions = {

      gtk = {
        enable = true;

        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.arclight.gruvbox-plus-icons;
        };

        cursorTheme = {
          name = "capitaine-cursors";
          package = pkgs.capitaine-cursors;
        };

        font = {
          name = "Inter";
          size = 12;
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
