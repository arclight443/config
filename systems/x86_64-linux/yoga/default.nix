{ config, pkgs, lib, ... }:

with lib;
with lib.arclight;
{
  imports = [ ./hardware.nix ];

  arclight = {
    archetypes = {
      workstation = enabled;
      gaming = enabled;
      finance = enabled;
    };

    security = {
      yubikey = enabled;
    };
  
  # 2-in-1 laptop features
  hardware.laptop.common = enabled;
  hardware.laptop.tabletpc = enabled;
  
  };

  # Syncthing
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  services = {
    syncthing = {
      enable = true;
      user = "${config.arclight.user.name}";
      dataDir = "/home/${config.arclight.user.name}";
      configDir = "/home/${config.arclight.user.name}/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      devices = {
        "pc" = { id = "TLWZQ66-6BYGTM3-UYQKSCN-R3VBMX3-SXJKHQ2-IG2MVVJ-3SFSSXR-3HBLOA5"; };
        "pixel6pro" = { id = "FNRJSFE-NGN2MMG-WZFBZQE-PF5LATW-WBDTYD5-OVDEAQY-F6KHWNZ-Q2KNLAL"; };
      };
      folders = {
        "Work" = {
          path = "/home/${config.arclight.user.name}/Work";
          devices = [ "pc" ];
          ignorePerms = false;
        };
        "Music" = {
          path = "/home/${config.arclight.user.name}/Music";
          devices = [ "pc" "pixel6pro" ];
        };
        "Sync" = {
          path = "/home/${config.arclight.user.name}/Sync";
          devices = [ "yoga" "pixel6pro" ];
        };
      };
    };
  };

  networking.hostName = "yoga";
  system.stateVersion = "23.05";
}

