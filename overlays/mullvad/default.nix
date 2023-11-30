{ channels, ... }:

final: prev:

{
  inherit (channels.master) mullvad mullvad-vpn;
}
