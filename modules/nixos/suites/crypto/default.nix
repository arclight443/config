{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.crypto;
  apps = {
    monero = enabled;
  };

in
{
  options.arclight.suites.crypto = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable crypto apps.";
  };

  config = mkIf cfg.enable { arclight = { inherit apps; }; };
}
