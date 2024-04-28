{ config, pkgs, inputs, ... }:

  let
    colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;

    backgroundColor = "#171717";

    logoColors = if config.arclight.colorscheme.oled then {
        color0 = "#363636";
        color1 = "#404040";
        color2 = "#363636";
        color3 = "#404040";
        color4 = "#363636";
        color5 = "#404040";
      } else {
        color0 = "#${colors.base09}";
        color1 = "#${colors.base0A}";
        color2 = "#${colors.base0B}";
        color3 = "#${colors.base0D}";
        color4 = "#${colors.base0E}";
        color5 = "#${colors.base08}";
      };

  in
  {
    fhd = inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
      inherit backgroundColor logoColors;
      width = 1920;
      height = 1080;
    };

    fhd-vertical = inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
      inherit backgroundColor logoColors;
      width = 1080;
      height = 1920;
      logoSize = 24.890625;
    };

    uwqhd = inputs.nix-wallpaper.packages.${pkgs.system}.default.override {
      inherit backgroundColor logoColors;
      width = 3440;
      height = 1440;
    };

  }
