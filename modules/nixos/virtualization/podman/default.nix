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
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    
    arclight.home.extraOptions = {
      programs.zsh.initExtra = ''
        source '${pkgs.podman}/share/zsh/site-functions/_podman'
        source '${pkgs.podman}/share/zsh/site-functions/_podman-remote'
      '';
    };

    #virtualisation = {
    #  docker.enable = true;
    #};
    #
    #arclight.user.extraGroups = [ "docker" ];

  };
}
