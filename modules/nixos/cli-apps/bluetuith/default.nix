{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.bluetuith;

in
{
  options.arclight.cli-apps.bluetuith = with types; {
    enable = mkBoolOpt false "Whether or not to enable bluetuith.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bluetuith
    ];

  };
}
