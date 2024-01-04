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
        "tridactyl/themes".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tridactyl/themes";           
        "tridactyl/tridactylrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tridactyl/tridactylrc"; 
      };
    };

    arclight.home = {

      extraOptions = {
        programs.firefox = {
          enable = true;

          package = with pkgs; wrapFirefox firefox-unwrapped {
            desktopName = "Firefox - Personal";
            wmClass = "Firefox - Personal";
            nativeMessagingHosts = [
              inputs.pipewire-screenaudio.packages.${pkgs.system}.default
            ];
            
            extraPolicies = {
              AppAutoUpdate = false;
              DisableAppUpdate = true;
              DisablePasswordSaving = true;
              DisablePrivateBrowsing = true;
              DisableFirefoxAccounts = true;
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
