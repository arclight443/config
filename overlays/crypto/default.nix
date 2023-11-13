{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) monero-gui monero-cli;
}
