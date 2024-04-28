{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.browsers.ungoogled-chromium;

  lineDesktopItem = pkgs.makeDesktopItem {
    name = "line";
    desktopName = "LINE";
    genericName = "LINE as a Chromium webapp";
    exec = if config.arclight.apps.mullvad.enable then ''
      mullvad-exclude ${pkgs.chromium}/bin/chromium --app="chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland --enable-wayland-ime %U
    '' else ''
      ${pkgs.chromium}/bin/chromium --app="chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland --enable-wayland-ime %U
    '';

    icon = ./icons/line.svg;
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    startupWMClass = "chrome-ophjlpahpchlmihnnnihgmmeilfjmjjc__index.html-Default";
    terminal = false;
    mimeTypes = [ "x-scheme-handler/line" ];
  };

in
{
  options.arclight.browsers.ungoogled-chromium = with types; {
    enable = mkBoolOpt false "Whether or not to enable ungoogled-chromium.";
    apps.line.enable = mkBoolOpt false "Whether or not to enable LINE chromium app.";
  };

  config = mkIf cfg.enable {
    arclight.home.extraOptions = {

      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=x11"
          "--enable-wayland-ime"
        ];
        extensions =
          let
            createChromiumExtensionFor = browserVersion: { id, sha256, version }:
              {
                inherit id;
                crxPath = builtins.fetchurl {
                  url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                  name = "${id}.crx";
                  inherit sha256;
                };
                inherit version;
              };
            createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
          in
          [
            (createChromiumExtension {
              # ublock origin
              id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
              sha256 = "07h94p8a02h23sqwbllhj47k3inlahnd4pbvqpim0wywa4yqzca3";
              version = "1.56.0";
            })
            (createChromiumExtension {
              # line
              id = "ophjlpahpchlmihnnnihgmmeilfjmjjc";
              sha256 = "0i5xz3wi8i54argv0hznzcd6ibzkh0ac60lx8k2wf1bvpx1kn185";
              version = "3.2.3";
            })
          ];
      };
    };

    environment.systemPackages = with pkgs; [ ]
      ++ optional cfg.apps.line.enable lineDesktopItem
    ;
  };
}
