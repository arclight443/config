{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.evolution;
in
{
  options.arclight.apps.evolution = with types; {
    enable = mkBoolOpt false "Whether or not to enable evolution.";
  };

  config = mkIf cfg.enable {

    programs.evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    #services.gnome.evolution-data-server.enable = lib.mkForce config.arclight.desktop.gnome.enable;
    services.gnome.evolution-data-server.enable = lib.mkForce true;

    environment.systemPackages =  with pkgs; [
      evolution
    ];

  };
}
