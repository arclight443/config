{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "MrOtherGuy";
  repo = "firefox-csshacks";
  rev = "05ad86ab51cc1550459d3cac6d8a8acc00bb4570";
  sha256 = "miPbSiWlkqETNy7PNuDErO49cXDHETTnn6igVDm2hbE=";
  name = "firefox-csshacks";
}
