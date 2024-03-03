{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.alacritty;
  colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;

in
{
  options.arclight.desktop.utils.alacritty = with types; {
    enable = mkBoolOpt false "Whether or not to enable alacritty";
  };

  config = mkIf cfg.enable {

    programs.alacritty = {
      enable = true;
      settings = {

        font = {
          normal.family = "MesloLGS NF";
          size = 11.5;
        };

        window.opacity = if config.arclight.colorscheme.oled then 1 else 0.8;
        window.padding = {
          x = 4;
          y = 4;
        };

        colors = {

            primary = {
              background = if config.arclight.colorscheme.oled then "#000000" else "#${colors.base00}";
              foreground = "#${colors.base05}";
            };

            normal = {
              black   = "#${colors.base00}";
              red     = "#${colors.base08}";
              green   = "#${colors.base0B}";
              yellow  = "#${colors.base0A}";
              blue    = "#${colors.base0D}";
              magenta = "#${colors.base0E}";
              cyan    = "#${colors.base0C}";
              white   = "#${colors.base05}";
            };

            bright = {
              black   = "#${colors.base03}";
              red     = "#${colors.base08}";
              green   = "#${colors.base0B}";
              yellow  = "#${colors.base0A}";
              blue    = "#${colors.base0D}";
              magenta = "#${colors.base0E}";
              cyan    = "#${colors.base0C}";
              white   = "#${colors.base05}";
            };

        };
      };
    };

    
  };
}
