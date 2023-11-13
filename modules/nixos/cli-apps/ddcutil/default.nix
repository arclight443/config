{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.ddcutil;
in
{
  options.arclight.cli-apps.ddcutil = with types; {
    enable = mkBoolOpt false "Whether or not to support monitor control with ddcutil.";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "i2c-dev" ];
    hardware.i2c.enable = true;

    arclight.user.extraGroups = [ "i2c" ];

    services.udev.extraRules = ''
      	KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';

    environment.systemPackages = with pkgs; [ ddcutil ddcui ];

  };
}

