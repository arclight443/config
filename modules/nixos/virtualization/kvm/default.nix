{ config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.virtualisation.kvm;
  user = config.arclight.user;
in
{
  options.arclight.virtualisation.kvm = with types; {
    enable = mkBoolOpt false "Whether or not to enable KVM virtualisation.";
    vfioIds = mkOpt (listOf str) [ ]
      "The hardware IDs to pass through to a virtual machine.";
    platform = mkOpt (enum [ "amd" "intel" ]) "amd"
      "Which CPU platform the machine is using.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [
        "kvm-${cfg.platform}"
        "vfio_virqfd"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio"
      ];
      kernelParams = [
        "${cfg.platform}_iommu=on"
        "${cfg.platform}_iommu=pt"
        "kvm.ignore_msrs=1"
      ];
      extraModprobeConfig = optionalString (length cfg.vfioIds > 0)
        "options vfio-pci ids=${concatStringsSep "," cfg.vfioIds}";
    };

    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        extraConfig = ''
          user="${user.name}"
        '';

        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu = {
          package = pkgs.qemu_kvm;
          ovmf = enabled;
          swtpm = enabled;
          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString config.users.users.${user.name}.uid}"
          '';
        };
      };
    };

    arclight = {
      user = { extraGroups = [ "qemu-libvirtd" "libvirtd" "disk" ]; };
    };
    
    #TODO Not needed after 23.11
    programs.dconf.enable = true;

    arclight.home.extraOptions = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };

  };
}
