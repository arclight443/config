{ config, pkgs, ... }:

pkgs.makeDesktopItem {
  name = "line";
  desktopName = "LINE";
  genericName = "LINE as a Chromium webapp";
  exec = if config.arclight.apps.mullvad.enable then ''
    mullvad-exclude ${pkgs.chromium}/bin/chromium --app="chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland
  '' else ''
    ${pkgs.chromium}/bin/chromium --app="chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland
  '';

  icon = ./line.svg;
  type = "Application";
  categories = [ "Network" "InstantMessaging" ];
  startupWMClass = "chrome-ophjlpahpchlmihnnnihgmmeilfjmjjc__index.html-Default";
  terminal = false;
  mimeTypes = [ "x-scheme-handler/line" ];
}

