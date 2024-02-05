inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.tools.cloud;
in
{
  options.arclight.tools.cloud = with types; {
    enable = mkBoolOpt false "Whether or not to enable cloud CLI tools.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      azure-cli
      awscli2
      terraform
      ansible
    ];
    
    programs.zsh.initExtra = ''
      complete -C '${pkgs.awscli2}/bin/aws_completer' aws
      source '${pkgs.azure-cli}/share/bash-completion/completions/az.bash'
    '';

  };
}
