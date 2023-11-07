{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.pandoc;

in
{
  options.arclight.cli-apps.pandoc = with types; {
    enable = mkBoolOpt false "Whether or not to enable pandoc.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pandoc
    ];

  };
}
