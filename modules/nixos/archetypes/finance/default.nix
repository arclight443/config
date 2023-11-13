{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.archetypes.finance;
in
{
  options.arclight.archetypes.finance = with types; {
    enable = mkBoolOpt false "Whether or not to enable finance archetype.";
  };

  config = mkIf cfg.enable {
    arclight.suites = {
      crypto = enabled;
    };
  };
}

