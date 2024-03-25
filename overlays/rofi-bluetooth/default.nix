{ ... }:

final: prev:

{
  rofi-bluetooth = prev.rofi-bluetooth.overrideAttrs (final: prev: {
    postInstall = ''
      substituteInPlace $out/bin/.rofi-bluetooth-wrapped \
        --replace "rofi -dmenu" "rofi -normal-window -theme \"~/.config/rofi/bluetooth.rasi\" -dmenu"
    '';
  });
}
