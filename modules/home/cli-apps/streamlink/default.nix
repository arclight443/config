{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.streamlink;

in
{
  options.arclight.cli-apps.streamlink = with types; {
    enable = mkBoolOpt false "Whether or not to enable streamlink.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      streamlink
    ];

  };
}
