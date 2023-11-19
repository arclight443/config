{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.services;
  arkenfox = import ../arkenfox.nix { inherit lib; };
  extensions = import ../extensions.nix { inherit pkgs; };
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Private";
  icon = "firefox-nightly";

in

{
  options.arclight.browsers.firefox.profiles.private = with types; {
    enable = mkBoolOpt false "Whether or not to enable ${profileName} profile for Firefox.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {
      programs.firefox.profiles.${lib.strings.toLower profileName} = {
        inherit settings search;
        id = 2;
        extensions = extensions.browsing ++ extensions.containers;
        userChrome = userchrome.cascade;

        arkenfox = lib.mkMerge ([
          {
            enable = true;
          }
        ] ++ [
          arkenfox.main
          {
            "0100"."0102"."browser.startup.page".value = 3;
          }
        ]);
      };

      xdg.desktopEntries = {
        "firefox-${lib.strings.toLower profileName}" = {
          inherit icon;
          name = "Firefox - ${profileName}";
          genericName = "Firefox (${profileName} profile)";
          exec = ''
            ${pkgs.firefox}/bin/firefox --name "Firefox - ${profileName}" -P ${lib.strings.toLower profileName} %U
          '';
          type = "Application";
          terminal = false;
          mimeType = [ "x-scheme-handler/http" "x-scheme-handler/https" ];
          settings = {
            StartupWMClass = "Firefox - ${profileName}";
          };
        };
      };

    };


  };
}
