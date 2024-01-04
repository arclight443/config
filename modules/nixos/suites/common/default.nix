{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.suites.common;
in
{
  options.arclight.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {

    arclight = {
      nix = enabled;

      cli-apps = {
        btop = enabled;
      };

      tools = {
        uutils = enabled;
        networking = enabled;
        event = enabled;
        git = enabled;
        cloud = enabled;
        misc = enabled;
      };

      hardware = {
        audio = enabled;
        storage = enabled;
        networking = enabled;
        thermal = enabled;
      };

      security = {
        doas = enabled;
        keyring = enabled;
      };

      services = {
        # Yubikeys
        openssh.enable = true;
        openssh.authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWCkieyuORfAgUFT8ZAYTePxHeDFHkoCeE64E8OCxuTE1TeokQqR76k73lTNkZo3ZR0QAJ8O2F8tHde0IyZ7iRfeg26a6+l06O5iLKOiz/i7NWiNm3TiowwFZ9J66C9DagIaf6yKg7Tu7AyQRzON8aJnyg2s2mRMxu9/Ub9GDo6BZ0wV0bwD4+zzi6f0+fLUGYA2brezxXqHutla+yPqtCN+PTWC6lncLwOFBAQtzhVPu1Ewm/g2svALn75TJYjTcghzIpctpG+XxilacxDHgcpiM01FqJbSnqd9yJ1Xr1OF7jX8+YxbuyMUsdBLA4VSGeCe7971Kjxjka/OPpmdPV1BK+gwSc4/bev8Ot1ayLS1EoAZWQIDYLP4hgiA0XEpMeFU9eybQXSUjxENIiZawnBMJXATOSrJeOjIarTZLLF8hK5wciRfj6u4C4J0cuqpGjnYVBmYikR+ATL7XI/vkb5xrymIen0bDoWFwnu0l93VNr1svnwsHF+4UV8jKY1Dc73O9oOILn8W88ZQrID3GMTxd/38F4szeSYRayiWMtQer/VcXhluwOO5s5Kkugt27ZQC9dGKq27/CymLj0OxGWHhDA3+enDp4IB3PakutKSWJed+1EBNkm8m1ZbXMCaBEWsS5iuswV4WvQoV2YOfQ3qo2IpQvV+riQ7meOc8Gv5Q== cardno:23_462_386"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIE6arxguPTdClH89lLQCS3cKFxCGnwzmMa1fOK8hs5GlAAAABHNzaDo= yubikey-alpha"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIM3mrGE2WrHPtRoQ3ahPSyXcamFJnZbTlUqE8amYS+NMAAAABHNzaDo= yubikey-beta"
        ];
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
    
    environment.systemPackages = [
      pkgs.plusultra.list-iommu
    ];

    services.xserver.excludePackages = with pkgs; [
      xterm
      nano
    ];

  };
}
