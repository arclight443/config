{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let 
  cfg = config.arclight.desktop.hyprland; 
  terminal = "LC_ALL=en_US.UTF-8" + ( if config.arclight.desktop.utils.kitty.enable then "${pkgs.kitty}/bin/kitty"
                                      else if  config.arclight.desktop.utils.alacritty.enable then "${pkgs.alacritty}/bin/alacritty"
                                      else "");
  colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;

  raise = inputs.raise.defaultPackage.${pkgs.system};
  pypr = inputs.pypr.packages.${pkgs.system}.default;

  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

in
{
  options.arclight.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
  };

  config = mkIf cfg.enable {

    home.packages = [
      raise
      pypr
      pkgs.socat
    ];

    arclight.desktop.utils = {
      gtk = enabled;
      qt = enabled;
      common = enabled;
      electron-support = enabled;
      alacritty = enabled;
      nautilus = enabled;
      fcitx5 = enabled;
      wlroots = enabled;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      plugins = [
        inputs.hyprgrass.packages.${pkgs.system}.default
      ];

      settings = {
        # Import test .conf
        source = "~/.config/hypr/test.conf";

        # Auto-start
        exec = [
          "pypr reload"
          "pgrep waybar && pkill -9 waybar; waybar"
        ];

        exec-once = [
          "fcitx5"
          "pypr"
          "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
          "sleep 1; swww-daemon; swww img /home/${config.arclight.user.name}/Pictures/nixos-wallpaper-fhd.png"
        ];

        # Env
        env = [
          # common
          "XCURSOR_SIZE,24"
          "WLR_NO_HARDWARE_CURSORS,1"
          "HYPRLAND_LOG_WLR,1"

          # qt
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_AUTO_SCREEN_SCALE_FACTOR,0"
          "QT_ENABLE_HIGHDPI_SCALING,0"

          # swww
          "SWWW_TRANSITION_FPS,60"
          "SWWW_TRANSITION,center"
          "SWWW_TRANSITION_DURATION,1"
        ];

        #monitor = [
        #  "eDP-1, 1920x1080@60, auto, auto, transform, 0"
        #];

        # Keybinds
        "$mod" = "SUPER";
        bind = [
          # General
          "$mod, r, exec, ${pkgs.hyprland}/bin/hyprctl reload"
          "$mod, f, fullscreen"
          "$mod, Q, killactive"
          "ALT, Tab, cyclenext"
          "CTRL SHIFT, q, exit"


          ", XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -m"
          ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"

          # Screenshots
          ",Print, exec, ${pkgs.grim}/bin/grim - | tee \"~/Pictures/Screenshots/Screenshot from $(date +'%Y-%m-%d %H-%M-%S').png\" | ${pkgs.wl-clipboard}/bin/wl-copy"
          "SHIFT, Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f - "
          "CTRL, Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f - "

          # CLI apps
          "$mod, return, exec, ${terminal} --class 'terminal' -e ${pkgs.zsh}/bin/zsh"
          "$mod CTRL, return, exec, ${pkgs.hyprland}/bin/hyprctl dispatch workspace empty && ${terminal} --class 'terminal' -e ${pkgs.zsh}/bin/zsh"

          "$mod SHIFT, v, exec, ${raise}/bin/raise --move-to-current --class 'neovim' --launch \"${terminal} --class 'neovim' -e ${pkgs.nvim}/bin/nvim\""
          "$mod CTRL, v, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'neovim' --launch \"${terminal} --class 'neovim' -e ${pkgs.nvim}/bin/nvim\""

          # Scratchpads
          "$mod, backslash, exec, ${pypr}/bin/pypr toggle terminal-float"
          "$mod, minus, exec, ${pypr}/bin/pypr toggle logs"
          "$mod, equal, exec, ${pypr}/bin/pypr toggle socket"
          "$mod, d, exec, XDG_DATA_DIRS='/home/${config.arclight.user.name}/.nix-profile/share/:/var/lib/flatpak/exports/share' ${pkgs.rofi}/bin/rofi -show drun -sort true -sorting-method fzf -theme '~/.config/rofi/launcher.rasi'"
          "$mod, m, exec, ${pypr}/bin/pypr toggle ncmpcpp"
          "$mod, s, exec, ${pypr}/bin/pypr toggle pulsemixer"
          "$mod, t, exec, ${pypr}/bin/pypr toggle btop"
          "$mod, y, exec, ${pypr}/bin/pypr toggle bluetuith"

          # GUI apps
          "$mod, b, exec, ${raise}/bin/raise --class 'firefox-personal' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-personal'\""
          "$mod SHIFT, b, exec, ${raise}/bin/raise --move-to-current --class 'firefox-personal' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-personal'\""
          "$mod CTRL, b, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'firefox-personal' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-personal'\""

          "$mod, n, exec, ${raise}/bin/raise --class 'firefox-services' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-services' -P 'services'\""
          "$mod SHIFT, n, exec, ${raise}/bin/raise --move-to-current --class 'firefox-services' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-services' -P 'services'\""
          "$mod CTRL, n, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'firefox-services' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-services' -P 'services'\""

          "$mod, c, exec, ${raise}/bin/raise --class 'Chromium-browser' --launch \"${pkgs.ungoogled-chromium}/bin/chromium-browser\""
          "$mod SHIFT, c, exec, ${raise}/bin/raise --move-to-current --class 'Chromium-browser' --launch \"${pkgs.ungoogled-chromium}/bin/chromium-browser\""
          "$mod CTRL, c, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'Chromium-browser' --launch \"${pkgs.ungoogled-chromium}/bin/chromium-browser\""

          "$mod SHIFT, p, exec, ${raise}/bin/raise --move-to-current --class 'org.keepassxc.KeePassXC' --launch \"${pkgs.keepassxc}/bin/keepassxc\""
          "$mod CTRL, p, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'org.keepassxc.KeePassXC' --launch \"${pkgs.keepassxc}/bin/keepassxc\""

          "$mod, e, exec, ${raise}/bin/raise --class 'evolution' --launch evolution"

          # Focus
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, j, movewindow, d"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, l, movewindow, r"

          # Switch workspaces
          "$mod, bracketleft,  workspace, m-1"
          "$mod, bracketright, workspace, m+1"

          "$mod SHIFT, bracketleft,  movetoworkspace, m-1"
          "$mod SHIFT, bracketright, movetoworkspace, m+1"
          "$mod CTRL, bracketleft, movetoworkspace, empty"
          "$mod CTRL, bracketright, movetoworkspace, empty"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod CTRL, mouse:272, resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 1"
          ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 1"
        ];

        # Inputs
        input = {
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
          accel_profile = "flat";
          sensitivity = 0;
        };

      };
    };

    xdg.configFile = {
      "hypr/test.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/test.conf";
      "hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}hypr/pyprland.toml";
    };

  };
}
