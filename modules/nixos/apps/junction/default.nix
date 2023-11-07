{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.junction;

in
{
  options.arclight.apps.junction = with types; {
    enable = mkBoolOpt false "Whether or not to enable junction.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {
      home.packages = with pkgs; [
        junction
      ];

    };
  };
}
