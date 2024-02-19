{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;

let
  cfg = config.arclight.browsers.firefox.profiles.personal;
  arkenfox = import ../arkenfox.nix { inherit lib; };
  extensions = import ../extensions.nix { inherit pkgs; };
  userchrome = import ../userchrome.nix { inherit pkgs lib; };
  search = import ../search.nix;
  settings = import ../settings.nix { inherit config; };

  profileName = "Personal";

in

{
  options.arclight.browsers.firefox.profiles.personal = with types; {
    enable = mkBoolOpt false "Whether or not to enable ${profileName} profile for Firefox.";
  };

  config = mkIf cfg.enable {

    programs.firefox.profiles.${lib.strings.toLower profileName} = {
      inherit search;
      id = 0;
      settings = settings // {
        "cookiebanners.service.mode" = "2";
      };
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
          "0100"."0103"."browser.startup.homepage".value = "https://duckduckgo.com";
        }
      ]);

    };


  };
}
