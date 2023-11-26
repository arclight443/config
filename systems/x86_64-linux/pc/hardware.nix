{ pkgs, config, lib, inputs, modulesPath, ... }:

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

  environment.etc.crypttab = {
    enable = true;
    text = ''
      cryptdata01 /dev/disk/by-uuid/eaa33059-78eb-46a4-b57f-0fa596b2ef21 - fido2-device=auto
      cryptdata02 /dev/disk/by-uuid/97115b04-b12e-43da-9ce0-90896dc01e98 - fido2-device=auto
      cryptdatavm /dev/disk/by-uuid/4a9233ba-aeb1-4ed6-b373-51bbe794edf6 - fido2-device=auto
    '';
  };

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      systemd.enable = true;
      luks.devices = {
        "cryptdata01".device = "/dev/disk/by-uuid/eaa33059-78eb-46a4-b57f-0fa596b2ef21";
        "cryptdata02".device = "/dev/disk/by-uuid/97115b04-b12e-43da-9ce0-90896dc01e98";
        "cryptdatavm".device = "/dev/disk/by-uuid/4a9233ba-aeb1-4ed6-b373-51bbe794edf6";
      };
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {

    # NixOS disk on ZFS
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
    

    # Data disks
    "/data/DATA_01" = {
     device = "/dev/mapper/cryptdata01";
      fsType = "ext4";
      options = [ "rw" ];
    };

    "/data/DATA_02" = {
      device = "dev/mapper/cryptdata02";
      fsType = "ext4";
      options = [ "rw" ];
    };

    "/data/DATA_VM" = {
      device = "dev/mapper/cryptdatavm";
      fsType = "ext4";
      options = [ "rw" ];
    };
    

    # Bind mounts to home
    "/home/${config.arclight.user.name}/Arclight" = {
      device = "/data/DATA_01/Arclight";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Documents" = {
      device = "/data/DATA_01/Documents";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Downloads" = {
      device = "/data/DATA_01/Downloads";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/GameFiles" = {
      device = "/data/DATA_01/GameFiles";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Music" = {
      depends = [ "/data/DATA_01" ];
      device = "/data/DATA_01/Music";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Pictures" = {
      depends = [ "/data/DATA_01" ];
      device = "/data/DATA_01/Pictures";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Repo" = {
      depends = [ "/data/DATA_01" ];
      device = "/data/DATA_01/Repo";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Secure" = {
      device = "/data/DATA_01/Secure";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Videos" = {
      device = "/data/DATA_01/Videos";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/VM" = {
      device = "/data/DATA_VM/";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

    "/home/${config.arclight.user.name}/Work" = {
      device = "/data/DATA_01/Work";
      options = [ "bind" "rw" "x-gvfs-hide" ];
    };

  };

  swapDevices = [
    { device = "/dev/disk/by-label/SWAP"; }
  ];
  
  # For ZFS. Generate with "head -c 8 /etc/machine-id"
  networking.hostId = "74517ea5";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
