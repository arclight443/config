{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) mullvad mullvad-vpn;
}
