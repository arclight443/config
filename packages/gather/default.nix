{ config, pkgs, ... }:

pkgs.makeDesktopItem {
  name = "gather";
  desktopName = "Gather";
  genericName = "Gather as a Chromium webapp";
  exec = if config.arclight.apps.mullvad.enable then ''
    mullvad-exclude ${pkgs.chromium}/bin/chromium --app="https://app.gather.town" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland
  '' else ''
    ${pkgs.chromium}/bin/chromium --app="https://app.gather.town" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland
  '';
  icon = ./gather.svg;
  type = "Application";
  categories = [ "Network" "InstantMessaging" ];
  startupWMClass = "chrome-app.gather.town__-Default";
  terminal = false;
  mimeTypes = [ "x-scheme-handler/gather" ];
}

