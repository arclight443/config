{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "eddyekofo94";
  repo = "gruvbox-flat.nvim";
  rev = "1dc35c81da30d297f82d438ff362cf1b01d36782";
  sha256 = "HbrULCrdXweX7Va5DaWlIPg/He6Iel95uIsj7ZP4hDY=";
  name = "gruvbox-flat-nvim-extras";
}
