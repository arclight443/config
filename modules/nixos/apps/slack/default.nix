{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.slack;
in
{
  options.arclight.apps.slack = with types; {
    enable = mkBoolOpt false "Whether or not to enable Slack.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
    ];

  };
}
