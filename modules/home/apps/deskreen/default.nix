{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.deskreen;

in
{
  options.arclight.apps.deskreen = with types; {
    enable = mkBoolOpt false "Whether or not to enable deskreen.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      deskreen
    ];

  };
}
