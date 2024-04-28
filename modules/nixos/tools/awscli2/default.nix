{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.tools.awscli2;
in
{
  options.arclight.tools.awscli2 = with types; {
    enable = mkBoolOpt false "Whether or not to enable awscli2.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;[
      awscli2
    ];

    arclight.home.extraOptions = {
      programs.zsh.initExtra = ''
        complete -C '${pkgs.awscli2}/bin/aws_completer' aws
      '';
    };

  };
}
