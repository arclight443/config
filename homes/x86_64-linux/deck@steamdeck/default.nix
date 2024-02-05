{ lib, pkgs, config, osConfig ? { }, format ? "unknown", ... }:

with lib.arclight;
{
  arclight = {
    user = {
      enable = true;
      name = "deck";
    };
    
    desktop = {
      hyprland = enabled;
    };

    browsers = {
      firefox.enable = true;
      firefox.profiles = {
        personal = enabled;
        services = enabled;
        private = enabled;
        discord = enabled;
      };
    };

    apps = {
      insomnia = enabled;
      dbeaver = enabled;
    };

    cli-apps = {
      home-manager = enabled;
      zsh = enabled;
      tmux = enabled;
      lazygit = enabled;
      neovim = enabled;
      pandoc = enabled;
      btop = enabled;
      ncmpcpp = enabled;
      ytdlp = enabled;
      chatblade = enabled;
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
    };

  };
}
