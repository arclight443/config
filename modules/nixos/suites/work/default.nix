{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.work;
in
{
  options.arclight.suites.work = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable apps for work.";
  };

  config = mkIf cfg.enable {
    arclight = {

      browsers = {
        ungoogled-chromium.enable = true;
        ungoogled-chromium.apps = {
          line = enabled;
          #gather = enabled;
        };
      };

      apps = {
        slack = enabled;
      };

      cli-apps = {
        openvpn = enabled;
        openfortivpn = enabled;
      };

    };

  };
}
