{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.desktop;
in
{
  options.arclight.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    arclight = {
      desktop = {
        gnome = enabled;
      };

      cli-apps = {
        ddcutil = enabled;
        ncmpcpp = enabled;
        ytdlp = enabled;
        chatblade = enabled;
      };

      browsers = {
        firefox.enable = true;
        firefox.profiles = {
          personal = enabled;
          services = enabled;
          private = enabled;
        };
      };

      apps = {
        junction = enabled;
        keepassxc = enabled;
        evolution = enabled;
        telegram = enabled;
        whatsapp = enabled;
        element = enabled;
        tor-browser = enabled;
        mpv = enabled;
        vlc = enabled;
        mpdevil = enabled;
        mullvad = enabled;
        nautilus = enabled;
      };

      services = {
        bluetooth = enabled;
        flatpak = enabled;
        printing = enabled;
      };

    };
  };
}
