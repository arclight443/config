{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.cli-apps.ncmpcpp;
in
{
  options.arclight.cli-apps.ncmpcpp = with types; {
    enable = mkBoolOpt false "Whether or not to enable ncmpcpp.";
  };

  config = mkIf cfg.enable {
    xdg.configFile."ncmpcpp/" = {
      source = ./config;
      recursive = true;
    };

    home.packages = with pkgs; [
      flac
      mpc-cli
      ffmpeg
    ];

    services = {
      mpd = {
        enable = true;
        musicDirectory = "~/Music";
        playlistDirectory = "/home/${config.arclight.user.name}/Music/PLAYLIST";
        extraConfig = ''
          audio_output {
             type  "pipewire"
             name  "Primary Audio Stream"
           }

           audio_output {
             type    "fifo"
             name    "Visualizer"
             path    "/tmp/mpd.fifo"
             format  "44100:16:1"
           }
        '';
      };
      mpd-mpris.enable = true;
    };

    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      mpdMusicDir = "~Music/";

      bindings = [
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "J"; command = [ "select_item" "scroll_down" ]; }
        { key = "K"; command = [ "select_item" "scroll_up" ]; }
      ];

      settings = {
        allow_for_physical_item_deletion = "yes";
      };

    };
  };
}
