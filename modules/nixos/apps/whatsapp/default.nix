{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.whatsapp;
in
{
  options.arclight.apps.whatsapp = with types; {
    enable = mkBoolOpt false "Whether or not to enable whatsapp.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      whatsapp-for-linux
    ];

  };
}
