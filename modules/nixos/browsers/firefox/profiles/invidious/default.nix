{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.invidious;
  arkenfox = import ../arkenfox.nix { inherit lib; };
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Invidious";

in

{
  options.arclight.browsers.firefox.profiles.invidious = with types; {
    enable = mkBoolOpt false "Whether or not to enable ${profileName} profile for Firefox.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {
      programs.firefox.profiles.${lib.strings.toLower profileName} = {
        inherit search settings;
        id = 4;
        extensions = [];
        userChrome = userchrome.autohide;
        arkenfox = lib.mkMerge ([
          {
            enable = true;
          }
        ] ++ [
          arkenfox.main
          {
            "0100"."0102"."browser.startup.page".value = 1;
            "5000"."5008"."browser.sessionstore.resume_from_crash" = false;
          }
        ]);

      };

      xdg.desktopEntries = {
        "firefox-${lib.strings.toLower profileName}" = {
          icon = ./invidious.svg;
          name = "Invidious (Firefox)";
          genericName = "Open source alternative front-end to YouTube";
          exec = ''
            ${pkgs.firefox}/bin/firefox --name "Invidious (Firefox)" -P ${lib.strings.toLower profileName} https://invidious.no-logs.com/
          '';
          type = "Application";
          categories = [ "Network" "InstantMessaging" ];
          terminal = false;
          mimeType = [ "x-scheme-handler/invidious" ];
          settings = {
            StartupWMClass = "Invidious (Firefox)";
          };

        };
      };

    };


  };
}
