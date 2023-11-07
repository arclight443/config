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
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
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

    "/home/${config.arclight.user.name}/Music" = {
      device = "/mnt/data/Media/Music";
      options = [ "bind" "rw" ];
    };

    "/home/${config.arclight.user.name}/Pictures" = {
      device = "/mnt/data/Media/Pictures";
      options = [ "bind" "rw" ];
    };

    "/home/${config.arclight.user.name}/Videos" = {
      device = "/mnt/data/Media/Videos";
      options = [ "bind" "rw" ];
    };

    "/home/${config.arclight.user.name}/Secure" = {
      device = "/mnt/data/Secure";
      options = [ "bind" "rw" ];
    };

    "/home/${config.arclight.user.name}/Art" = {
      device = "/mnt/data/Art";
      options = [ "bind" "rw" ];
    };

  };

  swapDevices = [
    { device = "/dev/disk/by-partlabel/swap"; }
  ];

  #hardware.opengl.enable = true;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidia.latest;
  #hardware.nvidia.modesetting.enable = true;
  #hardware.nvidia.forceFullCompositionPipeline = true;

  networking.hostName = "pc-nixos";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
