{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.arclight) enabled;

  cfg = config.arclight.home-manager;
in
{
  options.arclight.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {
    programs.home-manager = enabled;
    home.stateVersion = "23.11";

    arclight.home.mutableFile = {
      "/home/${config.arclight.user.name}/Arclight/dotfiles" = {
        url = "https://github.com/arclight443/dotfiles.git";
        type = "git";
      };
    };

  };
}
