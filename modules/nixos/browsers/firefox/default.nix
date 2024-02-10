{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{

  options.arclight.browsers.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;[
      tridactyl-native
    ];

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {
      xdg.configFile = {
        "tridactyl/".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tridactyl/";
      };
    };

    arclight.home = {

      extraOptions = {
        programs.firefox = {
          enable = true;

          policies = {
            AppAutoUpdate = false;
            DisableAppUpdate = true;
            DisableFirefoxAccounts = true;
            DisableFirefoxScreenshots = true;
            DisableFirefoxStudies = true;
            DisableForgetButton = true;
            DisableFormHistory = true;
            DisablePasswordReveal = true;
            DisableMasterPasswordCreation = true;
            DisablePocket = true;
            DisablePrivateBrowsing = true;
            DisableProfileImport = true;
            DisableSafeMode = true;
            DisableSetDesktopBackground = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
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

          package = with pkgs; wrapFirefox firefox-unwrapped {
            desktopName = "Firefox - Personal";
            wmClass = "\"Firefox - Personal\"";
            nativeMessagingHosts = [
              inputs.pipewire-screenaudio.packages.${pkgs.system}.default
            ];

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
