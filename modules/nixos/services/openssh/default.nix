{ options, config, pkgs, lib, host ? "", format ? "", inputs ? { }, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.services.openssh;

  user = config.users.users.${config.arclight.user.name};
  user-id = builtins.toString user.uid;

  # @TODO(jakehamilton): This is a hold-over from an earlier Snowfall Lib version which used
  # the specialArg `name` to provide the host name.
  name = host;

  default-key =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWCkieyuORfAgUFT8ZAYTePxHeDFHkoCeE64E8OCxuTE1TeokQqR76k73lTNkZo3ZR0QAJ8O2F8tHde0IyZ7iRfeg26a6+l06O5iLKOiz/i7NWiNm3TiowwFZ9J66C9DagIaf6yKg7Tu7AyQRzON8aJnyg2s2mRMxu9/Ub9GDo6BZ0wV0bwD4+zzi6f0+fLUGYA2brezxXqHutla+yPqtCN+PTWC6lncLwOFBAQtzhVPu1Ewm/g2svALn75TJYjTcghzIpctpG+XxilacxDHgcpiM01FqJbSnqd9yJ1Xr1OF7jX8+YxbuyMUsdBLA4VSGeCe7971Kjxjka/OPpmdPV1BK+gwSc4/bev8Ot1ayLS1EoAZWQIDYLP4hgiA0XEpMeFU9eybQXSUjxENIiZawnBMJXATOSrJeOjIarTZLLF8hK5wciRfj6u4C4J0cuqpGjnYVBmYikR+ATL7XI/vkb5xrymIen0bDoWFwnu0l93VNr1svnwsHF+4UV8jKY1Dc73O9oOILn8W88ZQrID3GMTxd/38F4szeSYRayiWMtQer/VcXhluwOO5s5Kkugt27ZQC9dGKq27/CymLj0OxGWHhDA3+enDp4IB3PakutKSWJed+1EBNkm8m1ZbXMCaBEWsS5iuswV4WvQoV2YOfQ3qo2IpQvV+riQ7meOc8Gv5Q== cardno:23_462_386";

  other-hosts = lib.filterAttrs
    (key: host:
      key != name && (host.config.arclight.user.name or null) != null)
    ((inputs.self.nixosConfigurations or { }) // (inputs.self.darwinConfigurations or { }));

  other-hosts-config = lib.concatMapStringsSep
    "\n"
    (name:
      let
        remote = other-hosts.${name};
        remote-user-name = remote.config.arclight.user.name;
        remote-user-id = builtins.toString remote.config.users.users.${remote-user-name}.uid;

        forward-gpg = optionalString (config.programs.gnupg.agent.enable && remote.config.programs.gnupg.agent.enable)
          ''
            RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent /run/user/${user-id}/gnupg/S.gpg-agent.extra
            RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent.ssh /run/user/${user-id}/gnupg/S.gpg-agent.ssh
          '';

      in
      ''
        Host ${name}
          User ${remote-user-name}
          ForwardAgent yes
          Port ${builtins.toString cfg.port}
          ${forward-gpg}
      ''
    )
    (builtins.attrNames other-hosts);
in
{
  options.arclight.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure OpenSSH support.";
    authorizedKeys =
      mkOpt (listOf str) [ default-key ] "The public keys to apply.";
    port = mkOpt port 2222 "The port to listen on (in addition to 22).";
    manage-other-hosts = mkOpt bool true "Whether or not to add other host configurations to SSH config.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = if format == "install-iso" then "yes" else "no";
        PasswordAuthentication = false;
      };

      extraConfig = ''
        StreamLocalBindUnlink yes
      '';

      ports = [
        22
        cfg.port
      ];
    };

    programs.ssh.extraConfig = ''
      Host *
        HostKeyAlgorithms +ssh-rsa

      ${optionalString cfg.manage-other-hosts other-hosts-config}
    '';

    arclight.user.extraOptions.openssh.authorizedKeys.keys =
      cfg.authorizedKeys;

    arclight.home.extraOptions = {
      programs.zsh.shellAliases = foldl
        (aliases: system:
          aliases // {
            "ssh-${system}" = "ssh ${system} -t tmux a";
          })
        { }
        (builtins.attrNames other-hosts);
    };
  };
}
