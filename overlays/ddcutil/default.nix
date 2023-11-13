
{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) ddcutil ddcui;
}
