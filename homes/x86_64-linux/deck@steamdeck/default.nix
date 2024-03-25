{ lib, pkgs, config, osConfig ? { }, format ? "unknown", ... }:

with lib.arclight;

{

  arclight = {
    user = {
      enable = true;
      name = "deck";
    };

    colorscheme = {
      enable = true;
      theme = "gruvbox-material-dark-medium";
      oled = true;
    };

    home-manager = enabled;

    desktop = {
      hyprland = enabled;
    };

    syncthing = enabled;

    browsers = {
      firefox.enable = true;

      firefox.profiles = {
        personal = enabled;
        services = enabled;
        private = enabled;
        discord = enabled;
      };

      ungoogled-chromium.enable = true;
      ungoogled-chromium.apps = {
        line = enabled;
        #gather = enabled;
      };

    };

    apps = {
      insomnia = enabled;
      dbeaver = enabled;
      qpwgraph = enabled;
      youtube-music = enabled;
      junction = enabled;
      krita = enabled;
      remmina = enabled;
      deskreen = enabled;
      telegram = enabled;
      keepassxc = enabled;
      mission-center = enabled;
      vlc = enabled;
    };

    cli-apps = {
      zsh = enabled;
      tmux = enabled;
      lazygit = enabled;
      neovim = enabled;
      pandoc = enabled;
      btop = enabled;
      ncmpcpp = enabled;
      ytdlp = enabled;
      chatblade = enabled;
      pulsemixer = enabled;
      streamlink = enabled;
    };

    tools = {
      direnv = enabled;
      kubernetes = enabled;
      uutils = enabled;
      networking = enabled;
      event = enabled;
      git = enabled;
      cloud = enabled;
      misc = enabled;
    };

    system = {
      fonts = enabled;
      udiskie = enabled;
    };

  };
}
