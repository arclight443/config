{
  lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, plasma5Packages
, gnome-icon-theme
, hicolor-icon-theme
}:

stdenvNoCC.mkDerivation {
  pname = "gruvbox-plus-icons";
  version = "v5.2";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = "gruvbox-plus-icon-pack";
    rev = "v5.2";
    sha256 = "sha256-Eb+d0TUzTLrCHdf1liR11tPbxOdT8uBrWbhEAqNpMBc=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ plasma5Packages.breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Gruvbox-Plus-Dark $out/share/icons/
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark

    runHook postInstall
  '';

  dontDropIconThemeCache = true;
  dontBuild = true;
  dontConfigure = true;

}
