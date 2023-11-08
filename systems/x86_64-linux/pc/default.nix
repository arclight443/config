{ pkgs, lib, ... }:

with lib;
with lib.arclight;
{
  imports = [ ./hardware.nix ];

  arclight = {
    archetypes = {
      workstation = enabled;
      gaming = enabled;
    };

    security = {
      yubikey = enabled;
    };

  };

  networking.hostName = "pc";
  system.stateVersion = "23.05";
}

