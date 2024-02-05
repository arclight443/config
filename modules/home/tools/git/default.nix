{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.tools.git;
  gpg = config.arclight.security.gpg;
  user = config.arclight.user;
in
{
  options.arclight.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
  };

  config = mkIf cfg.enable {

    programs.git = {
      enable = true;
      inherit (cfg) userName userEmail;
      extraConfig = {
        init = { defaultBranch = "main"; };
      };
    };
  };
}
