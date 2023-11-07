{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.hardware.thermal;
in
{
  options.arclight.hardware.thermal = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for thermal status.";
  };

  config = mkIf cfg.enable {
    arclight.user.extraGroups = [ "adm" ];
    environment.systemPackages = with pkgs; [ lm_sensors ];
  };
}
