{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) awscli2;
}
