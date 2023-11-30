{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.mullvad;
in
{
  options.arclight.apps.mullvad = with types; {
    enable = mkBoolOpt false "Whether or not to enable Mullvad VPN.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mullvad
      mullvad-vpn
    ];

    services.mullvad-vpn.enable = true;

    #DNS workaround
    networking.resolvconf.enable = false;
    services.resolved.enable = true;
  };
}
