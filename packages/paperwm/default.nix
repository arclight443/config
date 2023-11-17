{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-paperwm";
  version = "44.13.2";

  src = fetchFromGitHub {
    owner = "paperwm";
    repo = "PaperWM";
    rev = "v${finalAttrs.version}";
    sha256 = "fdX+4el/1o2qyRp4UsAx/jUlSHTevKsY/408M0FgEz0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/gnome-shell/extensions/paperwm@paperwm.github.com"
    cp -r . "$out/share/gnome-shell/extensions/paperwm@paperwm.github.com"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { url = finalAttrs.meta.homepage; };

  meta = {
    homepage = "https://github.com/paperwm/PaperWM";
    description = "Tiled scrollable window management for Gnome Shell";
    changelog = "https://github.com/paperwm/PaperWM/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hedning AndersonTorres cab404 ];
    platforms = lib.platforms.all;
  };

  passthru.extensionUuid = "paperwm@paperwm.github.com";
})
