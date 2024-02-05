{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.desktop.utils.thunar;
in
{
  options.arclight.desktop.utils.thunar = with types; {
    enable = mkBoolOpt false "Whether to enable Thunar.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin

      gnome.file-roller
      ffmpegthumbnailer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-ugly
    ];
  };
}
