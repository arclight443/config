{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.helvum;

in
{
  options.arclight.apps.helvum = with types; {
    enable = mkBoolOpt false "Whether or not to enable helvum.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      helvum
    ];
  };
}
