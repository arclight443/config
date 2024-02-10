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

    xdg.configFile = {
      "tridactyl/".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tridactyl/";
    };

    home.packages = with pkgs; [
      (buildEnv
        {
          name = "scripts";
          paths = [ ./scripts ];
        }
      )
      tridactylnative
    ];

  };

}
