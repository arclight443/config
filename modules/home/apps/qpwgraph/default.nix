{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.qpwgraph;

in
{
  options.arclight.apps.qpwgraph = with types; {
    enable = mkBoolOpt false "Whether or not to enable qpwgraph.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qpwgraph
    ];
  };
}
