{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox;

in
{

  options.arclight.browsers.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;[
      tridactyl-native
    ];

    arclight.home = {
      configFile."tridactyl/tridactylrc".source = ./tridactylrc;
      extraOptions = {
        programs.firefox = {
          enable = true;
          #package = pkgs.firefox.overrideAttrs (oldAttrs: rec {
          #  buildCommand = builtins.replaceStrings [ "install -D -t $out/share/applications $desktopItem/share/applications/*" ] [ "" ] oldAttrs.buildCommand;
          #});
        package = with pkgs; wrapFirefox firefox-unwrapped {
          desktopName = "Firefox - Personal";
          wmClass = "Firefox - Personal";

          #extraNativeMessagingHosts = with pkgs; [
          #  tridactyl-native
          #];

          extraPolicies = {
            AppAutoUpdate = false;
            DisableAppUpdate = true;
            DisableMasterPasswordCreation = true;
            DisablePocket = true;
            DisableSetDesktopBackground = true;
            DontCheckDefaultBrowser = true;
            EnableTrackingProtection = true;
            FirefoxHome = {
              Highlights = false;
              Pocket = false;
              Snippets = false;
              SponsporedPocket = false;
              SponsporedTopSites = false;
            };
            NoDefaultBookmarks = true;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
            SanitizeOnShutdown = {
              FormData = true;
            };
            UseSystemPrintDialog = true;
          };
        };

          arkenfox = {
            enable = true;
            version = "master";
          };
        };

        home.file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

        home.packages = with pkgs; [
          (buildEnv
            {
              name = "scripts";
              paths = [ ./scripts ];
            }
          )
        ];

      };
    };

    arclight.system.env = {
      "MOZ_ENABLE_WAYLAND" = "1";
    };

  };
}
