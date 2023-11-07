{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.tor-browser;

in
{
  options.arclight.apps.tor-browser = with types; {
    enable = mkBoolOpt false "Whether or not to enable TOR browser.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tor-browser-bundle-bin
    ];
  };
}
