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

    colorscheme = {
      enable = true;
      theme = "gruvbox-material-dark-medium";
    };

    desktop.utils.kanshi = {
      profiles = {

        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1080@60Hz";
              scale = 1.5;
              adaptiveSync = false;
            }
          ];
        };

        docked-office = {
          outputs = [
            {
              criteria = "LG Electronics LG IPS FULLHD 709NTVS8C951";
              status = "enable";
              mode = "1920x1080@60Hz";
              scale = 1.25;
              adaptiveSync = false;
            }

            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        };

      };
    };

    # 2-in-1 laptop features
    hardware.laptop.common = enabled;
    hardware.laptop.tabletpc = enabled;

  };

  # Syncthing
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  #virtualisation.vmware.host.enable = true;

  services = {
    syncthing = {
      enable = true;
      user = "${config.arclight.user.name}";
      dataDir = "/home/${config.arclight.user.name}/.config/syncthing";
      configDir = "/home/${config.arclight.user.name}/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = { 
        devices = {
          "pc" = { id = "TLWZQ66-6BYGTM3-UYQKSCN-R3VBMX3-SXJKHQ2-IG2MVVJ-3SFSSXR-3HBLOA5"; };
          "pixel6pro" = { id = "FNRJSFE-NGN2MMG-WZFBZQE-PF5LATW-WBDTYD5-OVDEAQY-F6KHWNZ-Q2KNLAL"; };
          "steamdeck" = { id = "6UQOTZ3-XZ67UWJ-POQE3WJ-GUNE2VE-J2XADCX-2DPC67Z-CD74HFX-ALUBYQC"; };
        };
        folders = {

          "Work" = {
            path = "/home/${config.arclight.user.name}/Work";
            devices = [ "pc" ];
            ignorePerms = false;
          };

          "Music" = {
            path = "/home/${config.arclight.user.name}/Music";
            devices = [ "pc" "pixel6pro" "steamdeck" ];
          };

          "Sync" = {
            path = "/home/${config.arclight.user.name}/Sync";
            devices = [ "pc" "pixel6pro" "steamdeck" ];
          };

          "Secure" = {
            path = "/home/${config.arclight.user.name}/Secure";
            devices = [ "steamdeck" ];
          };

        };
      };

    };
  };

  networking.hostName = "yoga";
  system.stateVersion = "23.05";
}

