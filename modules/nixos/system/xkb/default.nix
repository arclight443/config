{ options, config, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.system.xkb;
in
{
  options.arclight.system.xkb = with types; {
    enable = mkBoolOpt false "Whether or not to configure xkb.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "us,th,jp";
      xkbOptions = "caps:escape";
    };
  };
}
