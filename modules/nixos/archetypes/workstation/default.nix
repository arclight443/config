{ options, config, lib, pkgs, ... }:
with lib;
with lib.arclight;
let cfg = config.arclight.archetypes.workstation;
in
{
  options.arclight.archetypes.workstation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the workstation archetype.";
  };

  config = mkIf cfg.enable {
    arclight = {
      suites = {
        common = enabled;
        desktop = enabled;
        graphics = enabled;
        development = enabled;
        work = enabled;
      };

    };
  };
}
