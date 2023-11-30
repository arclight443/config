{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.thunderbird;
in
{
  options.arclight.apps.thunderbird = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for thunderbird.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      thunderbird
    ];

    services.gnome.evolution-data-server.enable = config.arclight.desktop.gnome.enable;

  };
}
