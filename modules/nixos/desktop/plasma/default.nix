{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.plasma;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";
  terminal = if       config.arclight.desktop.utils.kitty.enable then "kitty"
             else if  config.arclight.desktop.utils.alacritty.enable then "alacritty"
             else "";

in
{
  options.arclight.desktop.plasma = with types; {
    enable = mkBoolOpt false "Whether or not to use KDE Plasma as the desktop environment.";
  };

  config = mkIf cfg.enable {
    arclight.system.xkb.enable = true;

    arclight.desktop.utils = {
      common = enabled;
      gtk = enabled;
      qt = enabled;
      electron-support = enabled;
      alacritty = enabled;
      fcitx5 = enabled;
      nautilus = enabled;
      sddm = enabled;
    };
  
    services.desktopManager.plasma6.enable = true;

  };
}
