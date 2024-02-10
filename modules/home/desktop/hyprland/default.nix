{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.hyprland;
  terminal = if       config.arclight.desktop.utils.kitty.enable then "kitty"
             else if  config.arclight.desktop.utils.alacritty.enable then "alacritty"
             else "";
in
{
  options.arclight.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
  };

  config = mkIf cfg.enable {
    
    home.packages = with pkgs; [
      inputs.raise.defaultPackage.${pkgs.system}
    ];

    arclight.desktop.utils = {
      gtk = enabled;
      qt = enabled;
      common = enabled;
      electron-support = enabled;
      kitty = enabled;
      thunar = enabled;
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
          "pgrep waybar && pkill -9 waybar; waybar"
          "pgrep ulauncher && pkill -9 ulauncher; ulauncher --hide-window"
        ];

        exec-once = [
          "wvkbd-mobintl --hidden -L 150"
          "fcitx5"
          "swaync"
          "nm-applet --indicator"
          "blueman-applet"
          "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
          "sleep 1; swww init"
        ];

        # Env
        env = [
          #"GDK_SCALE,2"
          "XCURSOR_SIZE,24"
          "WLR_NO_HARDWARE_CURSORS,1"
          "HYPRLAND_LOG_WLR,1"
        ];

        monitor = [
          "eDP-1, 1920x1080@60, auto, auto, transform, 0"
        ];

        # Keybinds
        "$mod" = "SUPER";
        bind = [
          # Launch
          "$mod, return, exec, kitty"
          "$mod, Q, killactive"

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
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
        ];

        # Inputs
        input = {
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
          accel_profile = "flat";
          sensitivity = 0;
        };

      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
    };

  };
}
