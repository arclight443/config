{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    git
    sops
    bind

    jq
    wl-clipboard

    # Language servers for various parts of the config that uses a language.
    lua-language-server
    pyright
    nil

    # Formatters...
    treefmt # The universal formatter (if you configured it).
    stylua # ...for Lua.
    black # ...for Python.
    nixpkgs-fmt # ...for Nix.

    # Mozilla addons-specific tooling.
    nur.repos.rycee.mozilla-addons-to-nix
  ];

}
