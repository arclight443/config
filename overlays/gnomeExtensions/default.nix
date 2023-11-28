{ channels, ... }:

final: prev:

{
  inherit (channels.master) gnomeExtensions;
}
