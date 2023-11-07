{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.openfortivpn;

in
{
  options.arclight.cli-apps.openfortivpn = with types; {
    enable = mkBoolOpt false "Whether or not to enable openfortivpn.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openfortivpn
    ];

    environment.etc."ppp/options".text = "ipcp-accept-remote";

  };
}
