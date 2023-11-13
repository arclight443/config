{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-vitals";
  version = "61.0.0";

  src = fetchFromGitHub {
    owner = "corecoding";
    repo = "Vitals";
    rev = "v${finalAttrs.version}";
    sha256 = "aZLco45lo8lAps4PGV6MIco+r6ZVIvI4wPqt0dhvOp0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/gnome-shell/extensions/Vitals@CoreCoding.com"
    cp -r . "$out/share/gnome-shell/extensions/Vitals@CoreCoding.com"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { url = finalAttrs.meta.homepage; };

  passthru.extensionUuid = "Vitals@CoreCoding.com";
})
