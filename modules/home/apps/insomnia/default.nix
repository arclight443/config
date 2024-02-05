{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.insomnia;

in
{
  options.arclight.apps.insomnia = with types; {
    enable = mkBoolOpt false "Whether or not to enable insomnia.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      insomnia
    ];
  };
}
