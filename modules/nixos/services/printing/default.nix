{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.services.printing;

in
{
  options.arclight.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to enable printing (IPP everywhere for Apple-compatible printers).";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        brlaser
      ];
    };

    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.avahi.openFirewall = true;

  };
}
