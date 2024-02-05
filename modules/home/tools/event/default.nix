{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.tools.event;
in
{
  options.arclight.tools.event = with types; {
    enable = mkBoolOpt false "Whether or not to enable device event testing utilities.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      wev
      evtest
      libnotify
    ];
  };
}
