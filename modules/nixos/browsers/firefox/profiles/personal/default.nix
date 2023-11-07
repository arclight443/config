{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.personal;
  arkenfox = import ../arkenfox.nix { inherit lib; };
  extensions = import ../extensions.nix { inherit pkgs lib inputs; };
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Personal";
  icon = "firefox";

in

{
  options.arclight.browsers.firefox.profiles.personal = with types; {
    enable = mkBoolOpt false "Whether or not to enable ${profileName} profile for Firefox.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {
      programs.firefox.profiles.${lib.strings.toLower profileName} = {
        inherit search settings;
        id = 0;
        isDefault = true;
        extensions = extensions.base ++ extensions.browsing;
        userChrome = userchrome.cascade;

        arkenfox = lib.mkMerge ([
          {
            enable = true;
          }
        ] ++ [
          arkenfox.main
          {
            "0100"."0102"."browser.startup.page".value = 1;
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
          mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "text/mml" "x-scheme-handler/http" "x-scheme-handler/https" "application/pdf" ];
          settings = {
            StartupWMClass = "Firefox - ${profileName}";
          };
        };
      };

    };


  };
}
