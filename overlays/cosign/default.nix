{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) cosign;
}
