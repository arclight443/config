{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.mpdevil;

in
{
  options.arclight.apps.mpdevil = with types; {
    enable = mkBoolOpt false "Whether or not to enable mpdevil.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpdevil
    ];
  };
}
