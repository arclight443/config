{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.hardware.laptop.common;
in
{
  options.arclight.hardware.laptop.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common laptop utilities.";
  };

  config = mkIf cfg.enable {
    # Backlight
    arclight.user.extraGroups = [ "video" ];
    programs.light.enable = true;

  };

}
