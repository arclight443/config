{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.monero;

in
{
  options.arclight.apps.monero = with types; {
    enable = mkBoolOpt false "Whether or not to enable monero.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      monero-gui
      monero-cli
    ];
  };
}
