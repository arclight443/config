{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.desktop.utils.nautilus;
in
{
  options.arclight.desktop.utils.nautilus = with types; {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      gnome.nautilus
      ffmpegthumbnailer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-ugly
    ];
  };
}
