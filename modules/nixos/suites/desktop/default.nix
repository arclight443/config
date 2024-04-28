{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.desktop;
  patchDesktop = pkg: appName: from: to:
    with pkgs; let
      zipped = lib.zipLists from to;
      # Multiple operations to be performed by sed are specified with -e
      sed-args = builtins.map
        ({ fst, snd }: "-e 's#${fst}#${snd}#g'")
        zipped;
      concat-args = builtins.concatStringsSep " " sed-args;
    in
    lib.hiPrio
      (pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        ${gnused}/bin/sed ${concat-args} \
         ${pkg}/share/applications/${appName}.desktop \
         > $out/share/applications/${appName}.desktop
      '');

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
        #hyprland = enabled;
      };

      cli-apps = {
        ddcutil = enabled;
        ncmpcpp = enabled;
        ytdlp = enabled;
        chatblade = enabled;
        bluetuith = enabled;
        pulsemixer = enabled;
        streamlink = enabled;
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
        fractal = enabled;
        tor-browser = enabled;
        mission-center = enabled;
        onlyoffice = enabled;
        mpv = enabled;
        vlc = enabled;
        mullvad = enabled;
        remmina = enabled;
        picard = enabled;
        youtube-music = enabled;
        looking-glass-client = enabled;
      };

      hardware = {
        keyboard = enabled;
      };

      services = {
        bluetooth = enabled;
        #flatpak = enabled;
        printing = enabled;
        upower = enabled;
      };

    };

    environment.systemPackages = with pkgs; [ ]
      ++ optional config.arclight.apps.looking-glass-client.enable 
        (patchDesktop looking-glass-client "looking-glass-client" [ "^Terminal=true" ] [ "Terminal=false"] )
      ++ optional (!config.arclight.apps.mullvad.enable && config.arclight.apps.slack.enable)
        (patchDesktop slack "slack" [ "^Exec=.*"] [ "Exec=${pkgs.slack}/bin/slack -s --enable-wayland-ime %U" ])
      ++ optional (config.arclight.apps.mullvad.enable && config.arclight.apps.slack.enable)
        (patchDesktop slack "slack" [ "^Exec=.*"] [ "Exec=mullvad-exclude ${pkgs.slack}/bin/slack -s --enable-wayland-ime %U" ])
      ++ optional (config.arclight.apps.mullvad.enable && config.arclight.apps.steam.enable)
        (patchDesktop steam "steam" [ "^Exec=" ] [ "Exec=mullvad-exclude " ])
      ++ optional (config.arclight.apps.mullvad.enable && config.arclight.apps.evolution.enable) 
        (patchDesktop evolution "org.gnome.Evolution" [ "^Exec=" ] [ "Exec=mullvad-exclude "])
      ++ optional (config.arclight.apps.mullvad.enable && config.arclight.browsers.ungoogled-chromium.enable) 
        (patchDesktop ungoogled-chromium "chromium-browser" [ "^Exec" ] [ "Exec=mullvad-exclude " ])
    ;
  };
}
