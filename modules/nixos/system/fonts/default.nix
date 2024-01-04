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
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts = {
      packages = with pkgs;
        [
          material-icons
          meslo-lgs-nf
          kanit-font
          inter
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          (nerdfonts.override { fonts = [ "Hack" "FiraCode" "Iosevka" ]; })
        ] ++ cfg.fonts;
      fontconfig = {
        defaultFonts = {
          serif = [ "Noto Serif Thai" ];
          sansSerif = [ "Noto Sans Thai" ];
          monospace = [ "MesloLGS NF Regular" ];
        };
      };
      fontDir.enable = true;
    };

  };
}
