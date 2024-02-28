{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.tools.misc;
in
{
  options.arclight.tools.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # Performance monitoring
      bottom

      # Formatter/Fuzzy Finder
      fzf
      jq

      # Archive
      p7zip
      file
      unzip
      unar

      # Process
      killall

      # Other
      clac
    ];
  };
}