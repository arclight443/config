{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.krita;

in
{
  options.arclight.apps.krita = with types; {
    enable = mkBoolOpt false "Whether or not to enable krita.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      krita
    ];
  };
}
