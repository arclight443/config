{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.ymuse;

in
{
  options.arclight.apps.ymuse = with types; {
    enable = mkBoolOpt false "Whether or not to enable ymuse.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ymuse
    ];
  };
}
