{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.neovim;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.cli-apps.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      # Formatter
      stylua
      shfmt
      alejandra
      black
      nodePackages.prettier
      nixpkgs-fmt

      # LSP
      vscode-langservers-extracted
      lua-language-server
      ruff-lsp
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      
      terraform
      terraform-ls
      dockerfile-language-server-nodejs
      docker-compose-language-service
      yaml-language-server
      nil
      
      # Other dependencies
      gcc
      gnumake
    ];


    environment.variables = {
      # PAGER = "page";
      # MANPAGER =
      #   "page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'";
      PAGER = "less";
      MANPAGER = "less";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      EDITOR = "nvim";
    };

    arclight.home.extraOptions = { config, pkgs, ... }: {
      
      programs.neovim.enable = true;

      xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

      programs.zsh.shellAliases.vimdiff = "nvim -d";
      programs.bash.shellAliases.vimdiff = "nvim -d";
      programs.fish.shellAliases.vimdiff = "nvim -d";

    };

  };
}
