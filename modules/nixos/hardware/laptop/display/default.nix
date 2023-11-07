{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.hardware.laptop.displaylink;
in
{
  options.arclight.hardware.laptop.displaylink = with types; {
    enable = mkBoolOpt false "Whether or not to enable DisplayLink drivers.";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  };

}
