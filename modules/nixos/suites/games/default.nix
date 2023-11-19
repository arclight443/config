{ config, lib, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.games;
  apps = {
    steam = enabled;
  };

in
{
  options.arclight.suites.games = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common games configuration.";
  };

  config = mkIf cfg.enable { arclight = { inherit apps; }; };
}
