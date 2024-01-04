{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.btop;

in
{
  options.arclight.cli-apps.btop = with types; {
    enable = mkBoolOpt false "Whether or not to enable btop.";
  };

  config = mkIf cfg.enable {

    arclight.home.extraOptions = {

      programs.btop = {
        enable = true;
        settings = {
          color_theme = "gruvbox_material_dark";
          vim_keys = true;
          truecolor = true;
          theme_background = false;
          force_tty = false;
        };
      };

    };

  };
}
