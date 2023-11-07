{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.element;

in
{
  options.arclight.apps.element = with types; {
    enable = mkBoolOpt false "Whether or not to enable Element Matrix client.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      element-desktop
      element-desktop-wayland
    ];

  };
}

