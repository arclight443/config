{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.dbeaver;

in
{
  options.arclight.apps.dbeaver = with types; {
    enable = mkBoolOpt false "Whether or not to enable dbeaver.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      dbeaver
    ];

  };
}
