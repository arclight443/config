{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.freetube;

in
{
  options.arclight.apps.freetube = with types; {
    enable = mkBoolOpt false "Whether or not to enable freetube.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freetube
    ];
  };
}
