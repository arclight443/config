{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.fcitx5;

in
{
  options.arclight.desktop.utils.fcitx5 = with types; {
    enable = mkBoolOpt false "Whether or not to enable fcitx5.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      "GTK_IM_MODULE" = mkForce "fcitx";
      "QT_IM_MODULE" = mkForce "fcitx";
      "GLFW_IM_MODULE" = mkForce "ibus";
      "XMODIFIERS" = mkForce "@im=fcitx";
    };

    i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
        ];
    };

    home.file."themes" = {
      source = ./themes;
      target = "/home/${config.arclight.user.name}/.local/share/fcitx5/themes";
      recursive = true;
    };

    xdg.configFile = {
      "fcitx5/conf/classicui.conf".source = ./config/conf/classicui.conf;
    };

  };

}
