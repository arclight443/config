{ pkgs, lib, ... }:

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

    desktop.gnome.suspend = false;
    virtualisation.kvm = {
      enable = true;
      platform = "amd";

      # RTX 3070Ti:
      # IOMMU Group 26 0a:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA102 [GeForce RTX 3070 Ti] [10de:2207] (rev a1)
      # IOMMU Group 26 0a:00.1 Audio device [0403]: NVIDIA Corporation GA102 High Definition Audio Controller [10de:1aef] (rev a1)
      
      # Windows drive:
      # IOMMU Group 15 01:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller 980 [144d:a809]
      vfioIds = ["10de:2207" "10de:1aef" "144d:a809"];
    };
  };
  
  #networking.bridges.bridge0.interfaces = [ "enp6s0" ];
  #networking.interfaces.bridge0 = {
  #  useDHCP = false;
  #  ipv4.addresses = [ {
  #    "address" = "192.168.2.0";
  #    "prefixLength" = 24;
  #    }
  #  ];
  #};

  networking.hostName = "pc";
  system.stateVersion = "23.05";
}

