{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.evolution;
  patchDesktop = pkg: appName: from: to: lib.hiPrio (pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
    ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
    ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
  '');
in
{
  options.arclight.apps.evolution = with types; {
    enable = mkBoolOpt false "Whether or not to enable evolution.";
  };

  config = mkIf cfg.enable {

    programs.evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    services.gnome.evolution-data-server.enable = lib.mkForce config.arclight.desktop.gnome.enable;

    environment.systemPackages =  with pkgs;[
      evolution
    ] ++ optional config.arclight.apps.mullvad.enable
    (patchDesktop evolution "org.gnome.Evolution" "^Exec=" "Exec=mullvad-exclude ") ;

  };
}
