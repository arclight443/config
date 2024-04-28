{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.hyprland;
  terminal = if       config.arclight.desktop.utils.kitty.enable then "kitty"
             else if  config.arclight.desktop.utils.alacritty.enable then "alacritty"
             else "";
  colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

  raise = inputs.raise.defaultPackage.${pkgs.system};
  pypr = inputs.pypr.packages.${pkgs.system}.default;

  laptop-docked = pkgs.writeShellApplication {
    name = "laptop-mode-switch";
    runtimeInputs = [];
    text = ''
      docked=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq 'map(select(.name == "eDP-1")) | if length > 0 then true else false end')
      if [[ $docked == "true" ]]; then
        $1
      else
        $2
      fi
    '';
  };

  iio-process = ''
    iio-hyprland "eDP-1" "swww clear ${colors.base00}; swww img ~/Pictures/Wallpapers/nixos-wallpaper-fhd.png" "swww clear ${colors.base00}; swww img ~/Pictures/Wallpapers/nixos-wallpaper-fhd-vertical.png"
  '';

  wvkbd-process = ''
    wvkbd-mobintl --hidden -L 200 --bg ${colors.base00} --fg ${colors.base01} --press ${colors.base03} --text ${colors.base05}
  '';

in
{
  options.arclight.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      raise
      pypr
      pkgs.socat
    ]
    ++ optionals config.arclight.hardware.laptop.tabletpc.enable [ 
      inputs.iio-hyprland.defaultPackage.${pkgs.system}
      laptop-docked
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
      sddm = enabled;
      kanshi = {
        enable = true;
        systemdTarget = "hyprland-session.target";
      };
    };

    arclight.system.xkb.enable = true;

    arclight.nix.extra-substituters = {
      "https://hyprland.cachix.org".key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdg.portal.config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    arclight.home.extraOptions = {

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
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
            "systemctl restart --user kanshi"
            "sleep 1; swww restore"
          ] ++ optional config.arclight.hardware.laptop.tabletpc.enable "pgrep iio-hyprland && pkill -9 iio-hyprland; ${iio-process}";

          exec-once = [
            "fcitx5"
            "swaync"
            "swayosd-server"
            "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
            "pypr"
            "sleep 1; swww-daemon"
          ] ++ optionals config.arclight.hardware.laptop.tabletpc.enable [ 
            "${iio-process}"
            "${wvkbd-process}"
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

          # Keybinds
          "$mod" = "SUPER";
          bind = [
            # General
            "$mod, r, exec, ${pkgs.hyprland}/bin/hyprctl reload"
            "$mod, f, fullscreen"
            "$mod, q, killactive"
            "ALT, Tab, cyclenext"
            "CTRL SHIFT, q, exit"
            "CTRL SHIFT, l, exec, ${pkgs.swaylock}/bin/swaylock --config ~/.config/swaylock/config"
            #", switch:Lid Switch, exec, pypr toggle_dpms"
            #", switch:off:Lid Switch, exec, systemctl suspend"
            ", XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"

            # Screenshots
            ",Print, exec, ${pkgs.grim}/bin/grim - | tee \"~/Pictures/Screenshots/Screenshot from $(date +'%Y-%m-%d %H-%M-%S').png\" | ${pkgs.wl-clipboard}/bin/wl-copy"
            "SHIFT, Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f - "
            "CTRL, Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f - "

            # CLI apps
            "$mod, return, exec, ${terminal} --class 'terminal' -e ${pkgs.zsh}/bin/zsh"
            "$mod CTRL, return, exec, ${pkgs.hyprland}/bin/hyprctl dispatch workspace empty && ${terminal} --class 'terminal' -e ${pkgs.zsh}/bin/zsh"

            "$mod, v, exec, ${raise}/bin/raise --class 'neovim' --launch \"${terminal} --class 'neovim' -e ${pkgs.nvim}/bin/nvim\""
            "$mod SHIFT, v, exec, ${raise}/bin/raise --move-to-current --class 'neovim' --launch \"${terminal} --class 'neovim' -e ${pkgs.nvim}/bin/nvim\""
            "$mod CTRL, v, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'neovim' --launch \"${terminal} --class 'neovim' -e ${pkgs.nvim}/bin/nvim\""

            # Scratchpads
            "$mod, backslash, exec, ${pypr}/bin/pypr toggle terminal-float"
            "$mod, minus, exec, ${pypr}/bin/pypr toggle logs"
            "$mod, equal, exec, ${pypr}/bin/pypr toggle socket"
            "$mod, apostrophe, exec, swaync-client -t"
            "$mod, d, exec, ${pkgs.rofi}/bin/rofi -normal-window -show drun -sort true -sorting-method fzf -theme '~/.config/rofi/launcher.rasi'"
            "$mod, m, exec, ${pypr}/bin/pypr toggle ncmpcpp"
            "$mod, s, exec, ${pypr}/bin/pypr toggle pulsemixer"
            "$mod, t, exec, ${pypr}/bin/pypr toggle btop"
            "$mod, y, exec, ${pypr}/bin/pypr toggle bluetuith"

            # GUI apps
            "$mod, b, exec, ${raise}/bin/raise --class 'firefox-personal' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-personal'\""
            "$mod SHIFT, b, exec, ${raise}/bin/raise --move-to-current --class 'firefox-personal' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-personal'\""
            "$mod CTRL, b, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'firefox-personal' --launch \"${pkgs.firefox}/bin/firefox --name 'firefox-personal'\""

            "$mod, n, exec, ${raise}/bin/raise --class 'firefox-services' --launch \"mullvad-exclude ${pkgs.firefox}/bin/firefox --name 'firefox-services' -P 'services'\""
            "$mod SHIFT, n, exec, ${raise}/bin/raise --move-to-current --class 'firefox-services' --launch \"mullvad-exclude ${pkgs.firefox}/bin/firefox --name 'firefox-services' -P 'services'\""
            "$mod CTRL, n, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'firefox-services' --launch \"mullvad-exclude ${pkgs.firefox}/bin/firefox --name 'firefox-services' -P 'services'\""

            "$mod, c, exec, ${raise}/bin/raise --class 'Chromium-browser' --launch \"mullvad-exclude ${pkgs.ungoogled-chromium}/bin/chromium-browser\""
            "$mod SHIFT, c, exec, ${raise}/bin/raise --move-to-current --class 'Chromium-browser' --launch \"mullvad-exclude ${pkgs.ungoogled-chromium}/bin/chromium-browser\""
            "$mod CTRL, c, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'Chromium-browser' --launch \"mullvad-exclude ${pkgs.ungoogled-chromium}/bin/chromium-browser\""

            "$mod SHIFT, p, exec, ${raise}/bin/raise --move-to-current --class 'org.keepassxc.KeePassXC' --launch \"${pkgs.keepassxc}/bin/keepassxc\""
            "$mod CTRL, p, exec, ${raise}/bin/raise --move-to-nearest-empty --class 'org.keepassxc.KeePassXC' --launch \"${pkgs.keepassxc}/bin/keepassxc\""

            "$mod, e, exec, ${raise}/bin/raise --class 'evolution' --launch \"mullvad-exclude evolution\""

            # Focus
            "$mod, h, movefocus, l"
            "$mod, j, movefocus, d"
            "$mod, k, movefocus, u"
            "$mod, l, movefocus, r"
            "$mod CTRL, h, workspace, empty"
            "$mod CTRL, l, workspace, empty"
            "$mod SHIFT, h, movewindow, l"
            "$mod SHIFT, j, movewindow, d"
            "$mod SHIFT, k, movewindow, u"
            "$mod SHIFT, l, movewindow, r"

            # Switch workspaces
            "$mod, bracketleft,  workspace, m-1"
            "$mod, bracketright, workspace, m+1"

            # Move windows across workspaces
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
            ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
            ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
            ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
            ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ];

        };
      };

      home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors";
        size = 24;
      };

    };

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      xdg.configFile = {
        "hypr/test.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/test.conf";
        "hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/pyprland.toml";
      };

    };

  };
}
