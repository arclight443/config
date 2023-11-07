{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.dconf;

in
{
  options.arclight.desktop.utils.dconf = with types; {
    enable = mkBoolOpt false "Whether or not to enable dconf and dconf-editor.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome.dconf-editor
      dconf2nix
    ];

  };
}
