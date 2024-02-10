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
        #gnome = enabled;
        hyprland = enabled;
      };

      cli-apps = {
        ddcutil = enabled;
        ncmpcpp = enabled;
        ytdlp = enabled;
        chatblade = enabled;
        bluetuith = enabled;
      };

      browsers = {
        firefox.enable = true;
        firefox.profiles = {
          personal = enabled;
          services = enabled;
          private = enabled;
          discord = enabled;
        };
      };

      apps = {
        junction = enabled;
        keepassxc = enabled;
        evolution = enabled;
        freetube = enabled;
        telegram = enabled;
        whatsapp = enabled;
        element = enabled;
        tor-browser = enabled;
        mission-center = enabled;
        onlyoffice = enabled;
        mpv = enabled;
        vlc = enabled;
        mpdevil = enabled;
        mullvad = enabled;
        remmina = enabled;
        picard = enabled;
        youtube-music = enabled;
      };

      hardware = {
        keyboard = enabled;
      };

      services = {
        bluetooth = enabled;
        #flatpak = enabled;
        printing = enabled;
      };

    };
  };
}
