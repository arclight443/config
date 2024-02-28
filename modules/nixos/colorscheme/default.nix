{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.colorscheme;
  colorSchemes = inputs.nix-colors.colorSchemes;

in
{
  options.arclight.colorscheme = with types; {
    enable = mkBoolOpt true "Whether or not to style programs with nix-colors.";
    theme = mkOpt (enum (builtins.attrNames colorSchemes)) "gruvbox-material-dark-medium"
      "base16 color theme to use.";
    oled = mkBoolOpt false "Whether or not the screen is OLED (enable true dark background if so).";
  };

}
