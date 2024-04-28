{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.development;
  apps = {
    insomnia = enabled;
    dbeaver = enabled;
    drawio = enabled;
  };
  cli-apps = {
    tmux = enabled;
    lazygit = enabled;
    neovim = enabled;
    pandoc = enabled;
  };
  tools = {
    azure-cli = enabled;
    direnv = enabled;
    kubernetes = enabled;
  };
  virtualisation = {
    podman = enabled;
  };
in
{
  options.arclight.suites.development = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      12345
      3000
      3001
      8080
      8081
    ];

    arclight = {
      inherit apps cli-apps virtualisation tools;

    };
  };
}
