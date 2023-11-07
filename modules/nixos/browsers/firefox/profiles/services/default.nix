{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.services;
  arkenfox = import ../arkenfox.nix { inherit lib; };
  extensions = import ../extensions.nix { inherit pkgs lib inputs; };
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Services";
  icon = "firefox_alt2";

in

{
  options.arclight.browsers.firefox.profiles.services = with types; {
    enable = mkBoolOpt false "Whether or not to enable ${profileName} profile for Firefox.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {
      programs.firefox.profiles.${lib.strings.toLower profileName} = {
        inherit search settings;
        id = 1;
        extensions = extensions.browsing ++ extensions.containers;
        userChrome = userchrome.cascade;
        arkenfox.enable = false;
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