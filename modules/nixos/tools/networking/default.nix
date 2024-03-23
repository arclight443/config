{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.tools.networking;
in
{
  options.arclight.tools.networking = with types; {
    enable = mkBoolOpt false "Whether or not to enable common networking utilities.";
  };

  config =
    mkIf cfg.enable {
      arclight.home.configFile."wgetrc".text = "";

      environment.systemPackages = with pkgs; [
        wget
        curl
        dig
        inetutils
        nmap
        netcat
        wavemon
        ookla-speedtest
      ];
    };
}
