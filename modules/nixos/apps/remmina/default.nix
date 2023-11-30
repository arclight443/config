{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.remmina;
in
{
  options.arclight.apps.remmina = with types; {
    enable = mkBoolOpt false "Whether or not to enable remmina.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      remmina
    ];

  };
}
