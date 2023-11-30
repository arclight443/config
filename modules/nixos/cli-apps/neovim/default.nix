{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.neovim;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]));

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
      
      programs.neovim = {
        enable = true;
        plugins = [
          treesitterWithGrammars
        ];

      };

      # Treesitter is configured as a locally developed module in lazy.nvim
      # we hardcode a symlink here so that we can refer to it in our lazy config
      home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
        recursive = true;
        source = treesitterWithGrammars;
      };

      xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

      programs.zsh.shellAliases.vimdiff = "nvim -d";
      programs.bash.shellAliases.vimdiff = "nvim -d";
      programs.fish.shellAliases.vimdiff = "nvim -d";

    };

  };
}
