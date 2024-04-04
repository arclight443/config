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

  laptop-docked = pkgs.writeShellApplication {
    name = "laptop-undocked";
    runtimeInputs = [];
    text = ''
      ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq 'map(select(.name == "eDP-1")) | if length > 0 then true else false end'
    '';
  };


in
{
  options.arclight.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      inputs.raise.defaultPackage.${pkgs.system}
      inputs.pypr.packages.${pkgs.system}.default
      socat
      hyprkeys
    ] ++ optional config.arclight.hardware.laptop.tabletpc.enable inputs.iio-hyprland.defaultPackage.${pkgs.system}
      ++ optional config.arclight.hardware.laptop.tabletpc.enable laptop-docked;

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
            "pgrep waybar && pkill -9 waybar; waybar"
          ] ++ optional config.arclight.hardware.laptop.tabletpc.enable "pgrep iio-hyprland && pkill -9 iio-hyprland; iio-hyprland";

          exec-once = [
            "fcitx5"
            "swaync"
            "swayosd-server"
            "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
            "pypr"
            #"sleep 1; swww init"
          ] ++ optional config.arclight.hardware.laptop.tabletpc.enable "iio-hyprland"
            ++ optional config.arclight.hardware.laptop.tabletpc.enable "wvkbd-mobintl --hidden -L 200 --bg ${colors.base00} --fg ${colors.base01} --press ${colors.base03} --text ${colors.base05}";

          # Env
          env = [
            #"GDK_SCALE,2"
            "XCURSOR_SIZE,24"
            "WLR_NO_HARDWARE_CURSORS,1"
            "HYPRLAND_LOG_WLR,1"
          ];

          #monitor = [
          #  "eDP-1, 1920x1080@60, auto, auto, transform, 0"
          #];

          # Keybinds
          "$mod" = "SUPER";
          bind = [
            # General
            "$mod, r, exec, hyprctl reload"
            "$mod, f, fullscreen"
            "$mod, q, killactive"
            "CTRL SHIFT, q, exit"
            "CTRL SHIFT, l, exec, swaylock --config ~/.config/swaylock/config"
            #", switch:Lid Switch, exec, pypr toggle_dpms"
            #", switch:off:Lid Switch, exec, systemctl suspend"
            ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"

            # Screenshots
            ",Print, exec, grim"
            "$mod, Print, exec, grim -g \"$(slurp)\""

            # CLI apps
            "$mod, return, exec, ${terminal} --class 'terminal' -e ${pkgs.zsh}/bin/zsh"
            "$mod CTRL, return, exec, hyprctl dispatch workspace empty && ${terminal} --class 'terminal' -e ${pkgs.zsh}/bin/zsh"

            "$mod, v, exec, raise --class 'neovim' --launch \"${terminal} --class 'neovim' -e nvim\""
            "$mod SHIFT, v, exec, raise --move-to-current --class 'neovim' --launch \"${terminal} --class 'neovim' -e nvim\""
            "$mod CTRL, v, exec, raise --move-to-nearest-empty --class 'neovim' --launch \"${terminal} --class 'neovim' -e nvim\""

            # Scratchpads
            "$mod, backslash, exec, pypr toggle terminal-float"
            "$mod, minus, exec, pypr toggle logs"
            "$mod, equal, exec, pypr toggle socket"
            "$mod, apostrophe, exec, swaync-client -t"
            "$mod, d, exec, rofi -normal-window -show drun -sort true -sorting-method fzf -theme '~/.config/rofi/launcher.rasi'"
            "$mod, m, exec, pypr toggle ncmpcpp"
            "$mod, s, exec, pypr toggle pulsemixer"
            "$mod, t, exec, pypr toggle btop"
            "$mod, i, exec, pypr toggle bluetuith"
            "$mod, p, exec, pypr toggle password"

            # GUI apps
            "$mod, b, exec, raise --class 'Firefox - Personal' --launch \"firefox --name 'Firefox - Personal'\""
            "$mod SHIFT, b, exec, raise --move-to-current --class 'Firefox - Personal' --launch \"firefox --name 'Firefox - Personal'\""
            "$mod CTRL, b, exec, raise --move-to-nearest-empty --class 'Firefox - Personal' --launch \"firefox --name 'Firefox - Personal'\""

            "$mod, n, exec, raise --class 'Firefox - Services' --launch \"firefox --name 'Firefox - Services' -P 'services'\""
            "$mod SHIFT, n, exec, raise --move-to-current --class 'Firefox - Services' --launch \"firefox --name 'Firefox - Services' -P 'services'\""
            "$mod CTRL, n, exec, raise --move-to-nearest-empty --class 'Firefox - Services' --launch \"firefox --name 'Firefox - Services' -P 'services'\""

            "$mod, c, exec, raise --class 'Chromium-browser' --launch \"mullvad-exclude chromium\""
            "$mod SHIFT, c, exec, raise --move-to-current --class 'Chromium-browser' --launch \"mullvad-exclude chromium\""
            "$mod CTRL, c, exec, raise --move-to-nearest-empty --class 'Chromium-browser' --launch \"mullvad-exclude chromium\""

            "$mod, e, exec, raise --class 'evolution' --launch 'evolution'"

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
