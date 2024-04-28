{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.fractal;

in
{
  options.arclight.apps.fractal = with types; {
    enable = mkBoolOpt false "Whether or not to enable fractal Matrix client.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      fractal
    ];

  };
}

