{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.services.flatpak;

in
{
  options.arclight.services.flatpak = with types; {
    enable = mkBoolOpt false "Whether or not to enable flatpak.";
  };

  config = mkIf cfg.enable {
    xdg.portal.enable = true;
    services.flatpak.enable = true;
  };
}
