{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.graphics;
  apps = {
    krita = enabled;
  };

in
{
  options.arclight.suites.graphics = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable art/graphics editing programs.";
  };

  config = mkIf cfg.enable { 
    arclight = { inherit apps; }; 
  };
}
