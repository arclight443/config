{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.desktop.utils.electron-support;
in
{
  options.arclight.desktop.utils.electron-support = with types; {
    enable = mkBoolOpt false
      "Whether to enable electron support in the desktop environment.";
  };

  config = mkIf cfg.enable {
    xdg.configFile."electron-flags.conf".source =
      ./electron-flags.conf;

    home.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}
