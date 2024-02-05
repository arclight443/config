{ lib, config, pkgs, osConfig ? { }, ... }:

let
  inherit (lib) types mkIf mkDefault mkMerge;
  inherit (lib.arclight) mkOpt;

  cfg = config.arclight.user;

  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  home-directory =
    if cfg.name == null then
      null
    else if is-darwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";
in
{
  options.arclight.user = {
    enable = mkOpt types.bool false "Whether to configure the user account.";

    name = mkOpt types.str "jump" "The name to use for the user account.";
    fullName = mkOpt types.str "Jump" "Full name of the user.";
    email = mkOpt types.str "waratch.p@outlook.com" "The email of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";

  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "arclight.user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "arclight.user.home must be set";
        }
      ];

      home = {
        username = mkDefault cfg.name;
        homeDirectory = mkDefault cfg.home;
      };
    }
  ]);
}
