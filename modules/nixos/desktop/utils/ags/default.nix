{ options, inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.ags;

in
{
  options.arclight.desktop.utils.ags = with types; {
    enable = mkBoolOpt false "Whether or not to enable ags.";
  };

  config = mkIf cfg.enable {
    
    arclight.home.extraOptions = {

      programs.ags = {
        enable = true;
        extraPackages = with pkgs; [
          gtksourceview
          webkitgtk
          accountsservice
        ];
      };

    };

  };

}

