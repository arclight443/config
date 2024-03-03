{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.qt;
  #env = {
  #  QT_STYLE_OVERRIDE = "kvantum";
  #  QT_QPA_PLATFORMTHEME = "gnome";
  #};

in
{
  options.arclight.desktop.utils.qt = with types; {
    enable = mkBoolOpt false "Whether or not to enable QT theming.";
  };

  config = mkIf cfg.enable {

    qt.enable = true;
    #qt.platformTheme = "gnome";
    #qt.style.name = "adwaita-dark";
    qt.platformTheme = "qtct";
    qt.style.name = "kvantum";
    #qt.style.package = pkgs.adwaita-qt;

    home.packages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
    ];

    xdg.configFile."Kvantum/" =
      {
        source = ./config;
        recursive = true;
      };

    #environment.variables = lib.mkForce env;
  };

}
