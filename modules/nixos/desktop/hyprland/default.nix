{ inputs, options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.hyprland;
  terminal = if       config.arclight.desktop.utils.kitty.enable then "kitty"
             else if  config.arclight.desktop.utils.alacritty.enable then "alacritty"
             else "";
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";

  hyprland-ipc = pkgs.writeShellApplication {
    name = "hyprland-ipc";
    checkPhase = "";
    runtimeInputs = [];
    text = ''
      handle() {
      	case $1 in
      	#closewindow*)
		    #  [[ $(hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.windows') -eq 0 ]] && hyprctl dispatch workspace previous
        #  ;;
        focusedmon*)
          pkill -SIGUSR2 waybar
          ;;
      	esac
      }
      ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
    '';
  };

in
{
  options.arclight.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
  };

  config = mkIf cfg.enable {
    
    environment.systemPackages = [
      inputs.raise.defaultPackage.${pkgs.system}
      hyprland-ipc
      pkgs.socat
      pkgs.hyprkeys
    ] ++ optional config.arclight.hardware.laptop.tabletpc.enable inputs.iio-hyprland.defaultPackage.${pkgs.system};

    arclight.desktop.utils = {
      gtk = enabled;
      qt = enabled;
      common = enabled;
      electron-support = enabled;
      kitty = enabled;
      thunar = enabled;
      fcitx5 = enabled;
      wlroots = enabled;
      sddm = enabled;
    };

    arclight.system.xkb.enable = true;

    arclight.nix.extra-substituters = { 
      "https://hyprland.cachix.org".key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
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
          ] ++ optional config.arclight.hardware.laptop.tabletpc.enable "pgrep waybar && pkill -9 iio-hyprland; iio-hyprland";

          exec-once = [
            "wvkbd-mobintl --hidden -L 150"
            "fcitx5"
            "swaync"
            "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
            "sleep 1; swww init"
          ] ++ optional config.arclight.hardware.laptop.tabletpc.enable "iio-hyprland";

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
            "$mod, Q, killactive"
            "CTRL SHIFT, q, exit"
            "CTRL SHIFT, l, exec, swaylock --config ~/.config/swaylock/config"

            # CLI apps
            "$mod, return, exec, kitty"
            "$mod, d, exec, rofi -show drun -sort true -sorting-method fzf -theme '~/.config/rofi/launcher.rasi'"
            "$mod SHIFT, m, exec, raise --class 'ncmpcpp' --launch 'hyprctl dispatch workspace empty && kitty --class ncmpcpp -e ncmpcpp --screen playlist --slave-screen visualizer'"
            "$mod SHIFT, s, exec, raise --class 'pulsemixer' --launch 'kitty --class 'pulsemixer' -e pulsemixer'"
            "$mod SHIFT, t, exec, raise --class 'btop' --launch \"hyprctl dispatch workspace empty && kitty --class 'btop' -e btop\""
            "$mod SHIFT, v, exec, raise --class 'neovim' --launch \"kitty --class 'neovim' -e nvim\""

            # GUI apps
            "$mod, b, exec, raise --class 'Firefox - Personal' --launch \"firefox --name 'Firefox - Personal'\""
            "$mod, s, exec, raise --class 'Firefox - Services' --launch \"firefox --name 'Firefox - Services' -P 'services'\""
            "$mod SHIFT, p, exec, raise --class 'org.keepassxc.KeePassXC' --launch 'keepassxc'"
            "$mod, e, exec, raise --class 'evolution' --launch 'evolution'"
            "$mod, y, exec, raise --class 'FreeTube' --launch 'Freetube'"

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
          ] ++ optional config.arclight.cli-apps.chatblade.enable "$mod, c, exec, raise --class 'chatblade-gpt-35-turbo' --launch 'chatblade-launch gpt-35-turbo'"
            ++ optional config.arclight.cli-apps.chatblade.enable "$mod SHIFT, c, exec, raise --class 'chatblade-gpt-4' --launch 'chatblade-launch gpt-4'";

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

    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      xdg.configFile = {
        "hypr/test.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr/test.conf";
      };

    };

  };
}
