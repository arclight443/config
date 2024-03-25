{ channels, ... }:

final: prev:

{
  inherit (channels.stable) awscli2;
}
