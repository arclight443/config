{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.services.upower;

in
{
  options.arclight.services.upower = with types; {
    enable = mkBoolOpt false "Whether or not to enable upower.";
  };

  config = mkIf cfg.enable {
    services.upower = {
      enable = true;
    };
  };
}
