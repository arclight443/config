{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.webcord;

in
{
  options.arclight.apps.webcord = with types; {
    enable = mkBoolOpt false "Whether or not to enable webcord.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      webcord-vencord
    ];
  };
}
