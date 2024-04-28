{ options, inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.wlroots.waybar;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.utils.wlroots.waybar = with types; {
    enable = mkBoolOpt false "Whether or not to enable waybar";
  };


  config = mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [
      arclight.waybar-battery
    ];

    arclight.home.extraOptions = {

      programs.waybar = {
        enable = true;
        #package = inputs.waybar.packages.${pkgs.system}.waybar;
      };

    };

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      xdg.configFile = {
        "waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
      };

    };

  };

}
