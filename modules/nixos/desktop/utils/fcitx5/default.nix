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
    arclight.system.env = {
      "NIX_PROFILES" = "${concatStringsSep " " (reverseList config.environment.profiles)}";
      "GTK_IM_MODULE" = "";
      "QT_IM_MODULE" = "fcitx5";
      "GLFW_IM_MODULE" = "ibus";
      "XMODIFIERS" = "@im=fcitx";
    };

    services.xserver.desktopManager.runXdgAutostartIfNone = true;

    i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
        ];
    };

    arclight.home = {
      file."themes" = {
        source = ./themes;
        target = "${config.users.users.${config.arclight.user.name}.home}/.local/share/fcitx5/themes";
        recursive = true;
      };

      configFile = {
        "fcitx5/conf/classicui.conf".source = ./config/conf/classicui.conf;
      };

    };
  };

}
