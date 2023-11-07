{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.ibus;

in
{
  options.arclight.desktop.utils.ibus = with types; {
    enable = mkBoolOpt false "Whether or not to enable ibus.";
  };

  config = mkIf cfg.enable {
    arclight.system.env = {
      "NIX_PROFILES" = "${concatStringsSep " " (reverseList config.environment.profiles)}";
      "GTK_IM_MODULE" = "ibus";
      "QT_IM_MODULE" = "ibus";
      "XMODIFIERS" = "@im=ibus";
    };

    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };


    arclight.home = {
      file."themes" = {
        source = ./themes;
        target = "${config.users.users.${config.arclight.user.name}.home}/.local/share/ibus/themes";
        recursive = true;
      };

      configFile = {
        "ibus/conf/classicui.conf".source = ./config/conf/classicui.conf;

        "mozc/ibus_config.textproto".text = ''
          # `ibus write-cache; ibus restart` might be necessary to apply changes.
          engines {
            name : "mozc-jp"
            longname : "Mozc"
            layout : "default"
            layout_variant : ""
            layout_option : ""
            rank : 80
          }
          active_on_launch: True
        '';
      };
    };
  };

}
