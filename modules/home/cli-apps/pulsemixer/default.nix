{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.pulsemixer;

in
{
  options.arclight.cli-apps.pulsemixer = with types; {
    enable = mkBoolOpt false "Whether or not to enable pulsemixer.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pulsemixer
    ];

  };
}
