{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.common;
in
{
  options.arclight.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {

    arclight = {
      nix = enabled;

      cli-apps = { };

      tools = {
        uutils = enabled;
        networking = enabled;
        event = enabled;
        git = enabled;
        cloud = enabled;
        misc = enabled;
      };

      hardware = {
        audio = enabled;
        storage = enabled;
        networking = enabled;
        thermal = enabled;
      };

      security = {
        doas = enabled;
        keyring = enabled;
      };

      services = {
        openssh = enabled;
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
    
    environment.systemPackages = [
      pkgs.plusultra.list-iommu
    ];

    services.xserver.excludePackages = with pkgs; [
      xterm
      nano
    ];

  };
}
