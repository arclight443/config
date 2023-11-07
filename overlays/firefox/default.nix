{ channels, ... }:

final: prev: {
  firefox = prev.firefox.overrideAttrs (oldAttrs: rec {
    buildCommand = builtins.replaceStrings [ "install -D -t $out/share/applications $desktopItem/share/applications/*" ] [ "" ] oldAttrs.buildCommand;
  });
}
