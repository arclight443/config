{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.syncthing;

in
{
  options.arclight.syncthing = with types; {
    enable = mkBoolOpt false "Whether or not to enable syncthing.";
  };

  config = mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}
