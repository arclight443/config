{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.cli-apps.ytdlp;
in
{
  options.arclight.cli-apps.ytdlp = with types; {
    enable = mkBoolOpt false "Whether or not to enable yt-dlp.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      yt-dlp
      ffmpeg
    ];

  };
}
