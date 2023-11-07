{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "andreasgrafen";
  repo = "cascade";
  rev = "2f70e8619ce5c721fe9c0736b25c5a79938f1215";
  sha256 = "1gf65iypcc8lzp2s5mwbf71n77c9ldr0g9ic2p9w13hdax1q3qqw";
  name = "firefox-cascade";
}
