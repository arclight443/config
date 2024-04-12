{ config, pkgs, inputs, ... }:

  let
    colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;
  in
  {
    nix-wallpaper = inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
      backgroundColor = if config.arclight.colorscheme.oled
        then "#000000"
        else "#${colors.base00}";
      logoColors = if config.arclight.colorscheme.oled then {
          color0 = "#83a598";
          color1 = "#458588";
          color2 = "#83a598";
          color3 = "#458588";
          color4 = "#83a598";
          color5 = "#458588";
        } else {
          color0 = "#${colors.base09}";
          color1 = "#${colors.base0A}";
          color2 = "#${colors.base0B}";
          color3 = "#${colors.base0D}";
          color4 = "#${colors.base0E}";
          color5 = "#${colors.base08}";
        };
      };
  }
