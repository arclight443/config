{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.desktop.utils.thunar;
in
{
  options.arclight.desktop.utils.thunar = with types; {
    enable = mkBoolOpt false "Whether to enable Thunar.";
  };

  config = mkIf cfg.enable {
    
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs = enabled;
    services.tumbler = enabled;

    # Enable support for browsing samba shares.
    networking.firewall.extraCommands =
      "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";

    environment.systemPackages = with pkgs; [
      gnome.file-roller
      ffmpegthumbnailer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-ugly
    ];
  };
}
