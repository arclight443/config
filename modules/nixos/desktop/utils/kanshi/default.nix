{ options, inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.kanshi;

in
{
  options.arclight.desktop.utils.kanshi = with types; {
    enable = mkBoolOpt false "Whether or not to enable kanshi.";
    systemdTarget = mkOpt str "hyprland-session.target" "Systemd target to bind to";
    profiles = mkOpt attrs { } "Monitor configuration for each host";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {

      services.kanshi = {
        enable = true;
        systemdTarget = mkAliasDefinitions options.arclight.desktop.utils.kanshi.systemdTarget;
        profiles = mkAliasDefinitions options.arclight.desktop.utils.kanshi.profiles;
      };

    };

  };

}

