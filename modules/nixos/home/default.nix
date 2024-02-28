{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.home;
in
{

  options.arclight.home = with types; {
    file = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `home.file`.");
    configFile = mkOpt attrs { }
      (mdDoc "A set of files to be managed by home-manager's `xdg.configFile`.");
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    
    arclight.home.mutableFile = {
      "/home/${config.arclight.user.name}/Arclight/dotfiles" = {
        url = "https://github.com/arclight443/dotfiles.git";
        type = "git";
      };
    };

    arclight.home.extraOptions = {

      imports = with inputs; [
        arkenfox.hmModules.default
        nur.hmModules.nur
        hyprland.homeManagerModules.default
        sops-nix.homeManagerModules.sops
        nix-colors.homeManagerModules.default
      ];

      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.arclight.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.arclight.home.configFile;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.arclight.user.name} =
        mkAliasDefinitions options.arclight.home.extraOptions;
    };

  };
}
