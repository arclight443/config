{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.virtualisation.podman;
in
{
  options.arclight.virtualisation.podman = with types; {
    enable = mkBoolOpt false "Whether or not to enable podman.";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    #virtualisation = {
    #  docker.enable = true;
    #};
    #
    #arclight.user.extraGroups = [ "docker" ];

  };
}
