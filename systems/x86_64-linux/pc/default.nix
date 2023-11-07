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

  };

  networking.hostName = "pc";
  system.stateVersion = "23.05";
}

