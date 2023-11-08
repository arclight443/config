{ config, lib, pkgs, inputs, modulesPath, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-amd
    common-gpu-amd
    common-pc
    common-pc-ssd
  ];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "rpool/local/root";
      fsType = "zfs";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    
    "/home" = {
      device = "rpool/safe/home";
      fsType = "zfs";
    };

    "/persist" = {
      device = "rpool/safe/persist";
      fsType = "zfs";
    };

    "/mnt/data_01" = {
      device = "/dev/disk/by-label/DATA_01";
      fsType = "auto";
      options = [ "rw" ];
    };

    "/mnt/data_02" = {
      device = "dev/disk/by-label/DATA_02";
      fsType = "auto";
      options = [ "rw" ];
    };

    #"/home/${config.arclight.user.name}/Music" = {
    #  device = "/mnt/data/Media/Music";
    #  options = [ "bind" "rw" ];
    #};
    #
    #"/home/${config.arclight.user.name}/Pictures" = {
    #  device = "/mnt/data/Media/Pictures";
    #  options = [ "bind" "rw" ];
    #};
    #
    #"/home/${config.arclight.user.name}/Videos" = {
    #  device = "/mnt/data/Media/Videos";
    #  options = [ "bind" "rw" ];
    #};
    #
    #"/home/${config.arclight.user.name}/Secure" = {
    #  device = "/mnt/data/Secure";
    #  options = [ "bind" "rw" ];
    #};
    #
    #"/home/${config.arclight.user.name}/Art" = {
    #  device = "/mnt/data/Art";
    #  options = [ "bind" "rw" ];
    #};

  };

  swapDevices = [
    { device = "/dev/disk/by-label/SWAP"; }
  ];
  
  #hardware.opengl.enable = true;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidia.latest;
  #hardware.nvidia.modesetting.enable = true;
  #hardware.nvidia.forceFullCompositionPipeline = true;
  
  # ZFS need this 
  # Generate with "head -c 8 /etc/machine-id"
  networking.hostId = "74517ea5";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
