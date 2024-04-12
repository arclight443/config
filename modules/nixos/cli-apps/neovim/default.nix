{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.neovim;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
    awk
    bash
    bicep
    c
    cpp
    comment
    css
    csv
    diff
    dockerfile
    gitcommit
    gitattributes
    gitignore
    git_config
    git_rebase
    go
    gomod
    gowork
    gosum
    gpg
    hcl
    html
    http
    hyprlang
    java
    javascript
    jq
    json5
    json
    kusto
    latex
    lua
    make
    markdown
    markdown_inline
    meson
    nix
    ninja
    python
    rasi
    regex
    ron
    rust
    toml
    terraform
    typescript
    scss
    ssh_config
    sql
    udev
    vim
    vimdoc
    vue
    yaml
    xml
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
      nixfmt-rfc-style

      gotools
      gofumpt
      gomodifytags
      impl
      delve

      # LSP
      vscode-langservers-extracted
      lua-language-server
      ruff-lsp
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      gopls
      rust-analyzer
      cargo
      taplo

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

      home.file."./.local/share/nvim/nix/nvim-treesitter/parser".source =
        let
          parsers = pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = treesitterWithGrammars.dependencies;
          };
        in 
          "${parsers}/parser";

      xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

      programs.zsh.shellAliases.vimdiff = "nvim -d";
      programs.bash.shellAliases.vimdiff = "nvim -d";
      programs.fish.shellAliases.vimdiff = "nvim -d";

    };

  };
}
