{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "chisui";
  repo = "zsh-nix-shell";
  rev = "v0.7.0";
  sha256 = "oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
  name = "zsh-nix-shell";

}
