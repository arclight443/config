{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.browsers.ungoogled-chromium;

in
{
  options.arclight.browsers.ungoogled-chromium = with types; {
    enable = mkBoolOpt false "Whether or not to enable ungoogled-chromium.";
    apps.line.enable = mkBoolOpt false "Whether or not to enable LINE chromium app.";
    apps.gather.enable = mkBoolOpt false "Whether or not to enable Gather chromium app";
  };

  config = mkIf cfg.enable {
    arclight.home.extraOptions = {

      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=x11"
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
              sha256 = "15pxy8nmk3803x8wkmyqy5zgi6vf6fh4df96jzkp282fw6pw5rxr";
              version = "1.52.2";
            })
            (createChromiumExtension {
              # line
              id = "ophjlpahpchlmihnnnihgmmeilfjmjjc";
              sha256 = "0ib6v6rszc38i5m771ai3w8bv0dhgv87jy17rnmsy2f7paa52vk3";
              version = "3.1.2";
            })
          ];
      };
    };

    environment.systemPackages = [ ]
      ++ optional cfg.apps.line.enable pkgs.arclight.line
      ++ optional cfg.apps.gather.enable pkgs.arclight.gather;
  };
}
