{ pkgs, lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "london-between";
  version = "0.1.0";

  src = fetchzip {
    url = "https://font.download/dl/font/londonbetween.zip";
    stripRoot = false;
    hash = "sha256-4sIQXqZBeLVrWXoN6COfezw5HeVZocPYywDjEuPQIDk=";
  };

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/share/fonts/truetype
    cp London*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

}
