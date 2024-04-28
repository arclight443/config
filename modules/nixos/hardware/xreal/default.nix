{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.hardware.xreal;
in
{
  options.arclight.hardware.xreal = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for xreal glasses.";
  };

  config = mkIf cfg.enable {
    arclight.user.extraGroups = [ "adm" ];
  };
}
