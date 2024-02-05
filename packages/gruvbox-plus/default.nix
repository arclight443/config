{ pkgs, lib, fetchFromGitHub, gtk3, breeze-icons, gnome-icon-theme, hicolor-icon-theme }:

pkgs.stdenv.mkDerivation rec {
  name = "gruvbox-plus-icon-pack";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = name;
    rev = "v${version}";
    sha256 = "S5+pTGNAlMIWiYl3d6Pyd8AbvUDLxnvfraTC3HX0BcE=";
  };

  #nativeBuildInputs = [ gtk3 ];

  #propagatedBuildInputs = [ breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons/
    cp -r $src/Gruvbox-Plus-Dark $out/share/icons/
  '';

  #gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark

  #dontDropIconThemeCache = true;
}

