{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.system.locale;
in
{
  options.arclight.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_SG.UTF-8";
      LC_IDENTIFICATION = "en_SG.UTF-8";
      LC_MEASUREMENT = "en_SG.UTF-8";
      LC_MONETARY = "en_SG.UTF-8";
      LC_NAME = "en_SG.UTF-8";
      LC_NUMERIC = "en_SG.UTF-8";
      LC_PAPER = "en_SG.UTF-8";
      LC_TELEPHONE = "en_SG.UTF-8";
      LC_TIME = "en_SG.UTF-8";
    };

    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "th_TH.UTF-8/UTF-8"
      "en_SG.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];

    console = { 
      keyMap = mkForce "us"; 
      earlySetup = true;
      packages = with pkgs; [ terminus_font ];
      font = "ter-u28n";
    };
  };
}
