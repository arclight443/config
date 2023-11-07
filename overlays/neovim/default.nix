{ channels, ... }:

final: prev:

{
  inherit (channels.unstable)
    neovim

    stylua
    shfmt
    alejandra
    black

    nodePackages
    vscode-langservers-extracted
    ruff-lsp
    lua-language-server
    terraform
    terraform-ls
    dockerfile-language-server-nodejs
    yaml-language-server
    nixd
    ;
}
