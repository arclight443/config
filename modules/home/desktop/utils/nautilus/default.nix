{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.nautilus;
  terminal = if       config.arclight.desktop.utils.kitty.enable then "kitty"
             else if  config.arclight.desktop.utils.alacritty.enable then "alacritty"
             else "";

in
{
  options.arclight.desktop.utils.nautilus = with types; {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      gnome.nautilus
      gnome.nautilus-python
      nautilus-open-any-terminal
      ffmpegthumbnailer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-ugly
    ];

    dconf.settings = {
      "com/github/stunkymonkey/nautilus-open-any-terminal" = {
        inherit terminal;
        new-tab = true;
      };
    };

  };
}
