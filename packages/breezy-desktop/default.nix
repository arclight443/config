{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "wheaney";
  repo = "breezy-desktop";
  rev = "v0.8.8";
  sha256 = "oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
  name = "breezy-desktop";

}
