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

    hardware.laptop.common = enabled;
    hardware.laptop.tabletpc = enabled;

  };

  networking.hostName = "yoga";
  system.stateVersion = "23.05";
}

