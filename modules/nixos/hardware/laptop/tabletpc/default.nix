{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.hardware.laptop.tabletpc;
in
{
  options.arclight.hardware.laptop.tabletpc = with types; {
    enable = mkBoolOpt false "Whether or not to enable tablet PC utilities";
  };

  config = mkIf cfg.enable {

    hardware.sensor.iio.enable = true;
    hardware.opentabletdriver.enable = config.arclight.desktop.utils.wlroots.enable;

    services.acpid.enable = true;
    services.gnome.at-spi2-core.enable = config.arclight.desktop.gnome.enable;

  };
}

