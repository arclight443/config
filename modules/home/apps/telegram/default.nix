{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.telegram;
in
{
  options.arclight.apps.telegram = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for telegram.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      telegram-desktop
    ];

  };
}
