{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.youtube-music;
in
{
  options.arclight.apps.youtube-music = with types; {
    enable = mkBoolOpt false "Whether or not to enable youtube-music.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      youtube-music
    ];

  };
}
