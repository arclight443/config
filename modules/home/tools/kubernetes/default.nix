inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.tools.kubernetes;
in
{
  options.arclight.tools.kubernetes = with types; {
    enable = mkBoolOpt false "Whether or not to enable Kubernets CLI tools.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      argocd
      kubernetes-helm
      kubectl
    ];
  };
}
