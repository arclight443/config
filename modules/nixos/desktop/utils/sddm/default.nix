{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.sddm;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.utils.sddm = with types; {
    enable = mkBoolOpt false "Whether or not to enable SDDM.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;[
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
      pkgs.arclight.sddm-theme
    ];

    services.xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        sddm.theme = "${pkgs.arclight.sddm-theme}";
      };
    };

  };
}
