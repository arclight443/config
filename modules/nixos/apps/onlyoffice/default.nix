{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.apps.onlyoffice;
in
{
  options.arclight.apps.onlyoffice = with types; {
    enable = mkBoolOpt false "Whether to enable OnlyOffice.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      onlyoffice-bin_7_5
    ];
  };
}
