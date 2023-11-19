{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.slack;
  patchDesktop = pkg: appName: from: to: lib.hiPrio (pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
    ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
    ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
  '');
in
{
  options.arclight.apps.slack = with types; {
    enable = mkBoolOpt false "Whether or not to enable Slack.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
    ] ++ optional config.arclight.apps.mullvad.enable
    (patchDesktop slack "slack" "^Exec=" "Exec=mullvad-exclude ") ;

  };
}
