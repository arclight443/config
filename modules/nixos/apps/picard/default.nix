{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.picard;
in
{
  options.arclight.apps.picard = with types; {
    enable = mkBoolOpt false "Whether or not to enable Picard.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      picard
    ];

  };
}
