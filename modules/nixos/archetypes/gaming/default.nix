{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.archetypes.gaming;
in
{
  options.arclight.archetypes.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable gaming archetype.";
  };

  config = mkIf cfg.enable {
    arclight.suites = {
      games = enabled;
    };
  };
}

