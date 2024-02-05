{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.tools.direnv;
in
{
  options.arclight.tools.direnv = with types; {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv = enabled;
    };
  };
}
