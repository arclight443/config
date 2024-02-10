{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.hardware.keyboard;
in
{
  options.arclight.hardware.keyboard = with types; {
    enable = mkBoolOpt false "Whether or not to enable mechanical keyboard support.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      via
    ];

  };
}
