{ channels, ... }:

final: prev:

{
  inherit (channels.master) kitty;
}
