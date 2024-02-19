{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.browsers.ungoogled-chromium;

  lineDesktopItem = pkgs.makeDesktopItem {
    name = "line";
    desktopName = "LINE";
    genericName = "LINE as a Chromium webapp";
    exec = ''
      ${pkgs.chromium}/bin/chromium --app="chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland --enable-wayland-ime %U
    '';
    
    icon = ./icons/line.svg;
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    startupWMClass = "chrome-ophjlpahpchlmihnnnihgmmeilfjmjjc__index.html-Default";
    terminal = false;
    mimeTypes = [ "x-scheme-handler/line" ];
  };

  gatherDesktopItem = pkgs.makeDesktopItem {
    name = "gather";
    desktopName = "Gather";
    genericName = "Gather as a Chromium webapp";
    exec = ''
      ${pkgs.chromium}/bin/chromium --app="https://app.gather.town" --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland --enable-wayland-ime %U
    '';
    icon = ./icons/gather.svg;
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    startupWMClass = "chrome-app.gather.town__-Default";
    terminal = false;
    mimeTypes = [ "x-scheme-handler/gather" ];
  };

in
{
  options.arclight.browsers.ungoogled-chromium = with types; {
    enable = mkBoolOpt false "Whether or not to enable ungoogled-chromium.";
    apps.line.enable = mkBoolOpt false "Whether or not to enable LINE chromium app.";
    apps.gather.enable = mkBoolOpt false "Whether or not to enable Gather chromium app";
  };

  config = mkIf cfg.enable {

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
            sha256 = "0w9zc8in4gqlhg5hngffdi763h4d2mizq86z91z6rkjsj7w403fl";
            version = "1.55.0";
          })
          (createChromiumExtension {
            # line
            id = "ophjlpahpchlmihnnnihgmmeilfjmjjc";
            sha256 = "1k4dx6h9c1qqv2li1mvkpijn1xzc68nqglbnnv44k202vix695a2";
            version = "3.2.2";
          })
        ];
    };

    home.packages = with pkgs; [ ] 
      ++ optional cfg.apps.line.enable lineDesktopItem
      ++ optional cfg.apps.gather.enable gatherDesktopItem;
  };
}
