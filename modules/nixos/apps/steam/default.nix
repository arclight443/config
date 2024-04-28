{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.apps.steam;
in
{
  options.arclight.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {

    programs.steam = {
      enable = true;

      package = pkgs.steam.override {
        extraEnv = {};
        extraPkgs = pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
      };

      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "-f"
          "-o 10"
        ];
      };

    };

    programs.gamescope = {
      enable = true;
      args = [
        "--rt"
        "-f"
        "-o 10"
      ];
    };

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      steam
      pkgs.plusultra.nix-get-protonup
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };

  };
}
