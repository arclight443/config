{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.services;
  extensions = import ../extensions.nix { inherit pkgs lib inputs; };
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Services";
  profileNameLower = lib.strings.toLower profileName;

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
        extensions = extensions.browsing ++ extensions.containers ++ extensions.streaming;
        userChrome = userchrome.cascade;
        arkenfox.enable = false;
      };

      xdg.desktopEntries = {
        "firefox-${profileNameLower}" = {
          inherit icon;
          name = "Firefox (${profileName})";
          genericName = "${profileName} profile for Firefox";
          exec = if config.arclight.apps.mullvad.enable then ''
            mullvad-exclude ${pkgs.firefox}/bin/firefox --name "firefox-${profileNameLower}" -P ${profileNameLower} %U
          '' else ''
            ${pkgs.firefox}/bin/firefox --name "firefox-${profileNameLower}" -P ${profileNameLower} %U
          '';
          type = "Application";
          terminal = false;
          mimeType = [ "x-scheme-handler/http" "x-scheme-handler/https" ];
          settings = {
            StartupWMClass = "firefox-${profileName}";
          };
        };
      };

    };


  };
}
