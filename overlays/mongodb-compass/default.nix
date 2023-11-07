{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) mongodb-compass;
}
