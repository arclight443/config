{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.services.bluetooth;

in
{
  options.arclight.services.bluetooth = with types; {
    enable = mkBoolOpt false "Whether or not to enable bluetooth.";
  };

  config = mkIf cfg.enable {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

  };
}
