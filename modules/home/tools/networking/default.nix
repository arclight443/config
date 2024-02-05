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
      xdg.configFile."wgetrc".text = "";

      home.packages = with pkgs; [
        wget
        curl
        dig
        inetutils
        nmap
        netcat
        ookla-speedtest
      ];
    };
}
