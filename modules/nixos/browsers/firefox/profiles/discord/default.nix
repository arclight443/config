{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.discord;
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Discord";
  icon = "discord";

in

{
  options.arclight.browsers.firefox.profiles.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable ${profileName} profile for Firefox.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {
      programs.firefox.profiles.${lib.strings.toLower profileName} = {
        inherit search;
        id = 3;
        settings = settings // {
          "browser.startup.page" = "1";
          "browser.startup.homepage" = "https://discord.com/channels/@me";
          "browser.sessionstore.resume_from_crash" = false;
        };
        extensions = [];
        userChrome = userchrome.autohide;
        arkenfox.enable = false;
      };

      xdg.desktopEntries = {
        "firefox-${lib.strings.toLower profileName}" = {
          inherit icon;
          name = "Discord (Firefox)";
          genericName = "All-in-one cross-platform voice and text chat for gamers";
          exec = if config.arclight.apps.mullvad.enable then ''
            mullvad-exclude ${pkgs.firefox}/bin/firefox --name "Discord (Firefox)" -P ${lib.strings.toLower profileName} %U
          '' else ''
            ${pkgs.firefox}/bin/firefox --name "Discord (Firefox)" -P ${lib.strings.toLower profileName} %U
          '';
          type = "Application";
          categories = [ "Network" "InstantMessaging" ];
          terminal = false;
          mimeType = [ "x-scheme-handler/discord" ];
          settings = {
            StartupWMClass = "Discord (Firefox)";
          };

        };
      };

    };


  };
}
