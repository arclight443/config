{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.mission-center;

in
{
  options.arclight.apps.mission-center = with types; {
    enable = mkBoolOpt false "Whether or not to enable mission-center.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mission-center
    ];
  };
}
