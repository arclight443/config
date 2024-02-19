{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.keepassxc;

in
{
  options.arclight.apps.keepassxc = with types; {
    enable = mkBoolOpt false "Whether or not to enable keepassxc.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      keepassxc
    ];
  };
}
