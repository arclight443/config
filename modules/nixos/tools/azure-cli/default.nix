inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.tools.azure-cli;

in
{
  options.arclight.tools.azure-cli = with types; {
    enable = mkBoolOpt false "Whether or not to enable azure-cli.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.azure-cli-extensions; [
      pkgs.azure-cli
      account
      acrquery
      acrtransfer
      ad
      adp
      aem
      ai-examples
      aks-preview
      alb
      alertsmanagement
      appservice-kube
      authV2
      automation
      azure-firewall
      bastion
      billing-benefits
      connection-monitor-preview
      costmanagement
      datafactory
      datamigration
      deploy-to-azure
      desktopvirtualization
      image-copy-extension
      image-gallery
      k8s-extension
      kusto
      log-analytics
      peering
      portal
      powerbidedicated
      purview
      reservation
      resource-graph
      sentinel
      site-recovery
      staticwebapp
      storage-blob-preview
      storage-mover
      storagesync
      stream-analytics
      subscription
      virtual-network-manager
      webapp
      workloads
    ];

    arclight.home.extraOptions = {
      programs.zsh.initExtra = ''
        source '${pkgs.azure-cli}/share/bash-completion/completions/az.bash'
      '';

    };

  };
}
