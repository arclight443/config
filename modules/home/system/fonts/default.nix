{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.system.fonts;
in
{
  options.arclight.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    home.packages = with pkgs; [ 
      font-manager 

      material-icons
      meslo-lgs-nf
      kanit-font
      inter
      roboto
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerdfonts
      cantarell-fonts
      font-awesome
      arclight.london-between
    ] ++ cfg.fonts;

    fonts.fontconfig.enable = true;

  };
}
