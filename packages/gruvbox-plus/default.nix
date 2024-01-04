{ pkgs, lib, fetchFromGitHub, gtk3, breeze-icons, gnome-icon-theme, hicolor-icon-theme }:

pkgs.stdenv.mkDerivation rec {
  name = "gruvbox-plus-icon-pack";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = name;
    rev = "v${version}";
    sha256 = "CpSMYCNtDcLpHbBaK1irsnDa6PuINjDqs4KVPpijj30=";
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

