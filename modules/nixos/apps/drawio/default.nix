{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.drawio;

in
{
  options.arclight.apps.drawio = with types; {
    enable = mkBoolOpt false "Whether or not to enable drawio.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      drawio
    ];

  };
}
