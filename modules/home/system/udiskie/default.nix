{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.system.udiskie;
in
{
  options.arclight.system.udiskie = with types; {
    enable = mkBoolOpt false "Whether or not to enale udiskie.";
  };

  config = mkIf cfg.enable {

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };

  };
}
