{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.openvpn;

in
{
  options.arclight.cli-apps.openvpn = with types; {
    enable = mkBoolOpt false "Whether or not to enable openvpn.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openvpn
    ];

  };
}
