inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.tools.uutils;
in
{
  options.arclight.tools.uutils = with types; {
    enable = mkBoolOpt false "Whether or not to enable Rust Uutils, GNU Coreutils replacement";
  };

  config = mkIf cfg.enable {

      programs.bat = {
        enable = true;
        config = {
          theme = "gruvbox-dark";
        };
      };

      home.shellAliases = {
        cat = "bat";
      };

      programs.eza = {
        enable = true;
        git = true;
        icons = true;
        extraOptions = [
          "--group-directories-first"
        ];
      };

      home.packages = with pkgs; [
        fd
        ripgrep
      ];

  };
}
