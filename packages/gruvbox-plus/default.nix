{ pkgs, lib, fetchFromGitHub, gtk3, breeze-icons, gnome-icon-theme, hicolor-icon-theme }:

pkgs.stdenv.mkDerivation rec {
  name = "gruvbox-plus-icon-pack";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = name;
    rev = "70f656919ef81592f2b57696399b60b76b73664d";
    sha256 = "1d2yjzjzag06qciia89f9fks95k2r3sl67ja5293svljmm924la3";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons/
    cp -r Gruvbox-Plus-Dark $out/share/icons/
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark
  '';

  dontDropIconThemeCache = true;
}

