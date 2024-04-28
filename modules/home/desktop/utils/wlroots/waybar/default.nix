{ options, inputs, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.wlroots.waybar;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";
  colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;
in
{
  options.arclight.desktop.utils.wlroots.waybar = with types; {
    enable = mkBoolOpt false "Whether or not to enable waybar";
  };


  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      arclight.waybar-battery
    ];

    programs.waybar = {
      enable = true;
      #package = inputs.waybar.packages.${pkgs.system}.waybar;
      settings = {
        position = "top";
        layer = "bottom";
        height = 32;
        modules-left = [ "custom/launcher" "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [
          "custom/borderleft" "tray" "custom/borderright"
          "custom/borderleft" "network" "bluetooth" "pulseaudio" "custom/borderright"
          "custom/borderleft" "cpu" "memory" "custom/bat0" "custom/borderright"
          "custom/borderleft" "password" "clock"
        ];

        "custom/bat0" = {
          exec = "${pkgs.arclight.waybar-battery}/bin/waybar-battery BAT0";
          return-type = "json";
          format = "{icon}<span size='x-small' foreground='#${colors.base05}'> {}</span>";
          format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip = false;
        };

        "custom/launcher" = {
          format = "<span foreground='#${colors.base0D}'>󱄅</span>";
          on-click = "${pkgs.procps}/bin/pgrep rofi > /dev/null && ${pkgs.procps}/bin/pkill -9 rofi || XDG_DATA_DIRS='/home/${config.arclight.user.name}/.nix-profile/share/:/var/lib/flatpak/exports/share' ${pkgs.rofi}/bin/rofi -normal-window -show drun -sort true -sorting-method fzf -theme '~/.config/rofi/launcher.rasi'";
          tooltip = false;
        };

        "custom/password" = {
          format = "";
          on-click = "${pkgs.procps}/bin/pgrep keepassxc > /dev/null && ${pkgs.procps}/bin/pkill -9 keepassxc || ${pkgs.keepassxc}/bin/keepassxc";
          tooltip = false;
        };

        "custom/borderleft" = {
          format = " ";
          tooltip = false;
        };

        "custom/borderright" = {
          format = " ";
          tooltip = false;
        };

        "clock" = {
            interval = 1;
            format = "{:%a, %b %d %H:%M}";
            tooltip = false;
            on-click = "${pkgs.procps}/bin/pgrep gnome-calendar > /dev/null && ${pkgs.procps}/bin/pkill -9 gnome-calendar || ${pkgs.gnome.gnome-calendar}/bin/gnome-calendar";
        };

        "pulseaudio" = {
          format = "<span size='12000'>{icon} </span>";
          format-muted = "<span size='12000' foreground='#${colors.base03}'>{icon} </span>";
          format-icons = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" ""];
          };
          tooltip = false;
          on-click = "${pkgs.procps}/bin/pgrep pavucontrol > /dev/null && ${pkgs.procps}/bin/pkill -9 pavucontrol || ${pkgs.pavucontrol}/bin/pavucontrol --tab=3";
        };

        "network" = {
          format = "";
          format-wifi = "󰖩 ";
          format-ethernet = "󰈀 ";
          format-disconnected = "<span foreground='#${colors.base03}'>󰲛 </span>";
          tooltip = false;
          max-length = 50;
        };

        "bluetooth" = {
          format-on = "<span size='small'></span> ";
          format-off = "<span foreground='#${colors.base03}'>󰂲</span> ";
          format-disabled = "<span foreground='#${colors.base03}'>󰂲</span> ";
          format-connected = " ";
          tooltip = false;
        };

        "tray" = {
            icon-size = 16;
            spacing = 5;
            reverse-direction = true;
        };

        "cpu" = {
          format = "󰍛<span size='x-small' foreground='#${colors.base05}'> {usage}%</span>";
          interval = 5;
          tooltip = false;
          on-click = "${pkgs.procps}/bin/pgrep missioncenter > /dev/null && ${pkgs.procps}/bin/pkill -9 missioncenter || ${pkgs.mission-center}/bin/missioncenter";
        };

        "memory" = {
          format = " <span size='x-small' foreground='#${colors.base05}'>{}%</span>";
          interval = 5;
          tooltip = false;
          on-click = "${pkgs.procps}/bin/pgrep missioncenter > /dev/null && ${pkgs.procps}/bin/pkill -9 missioncenter || ${pkgs.mission-center}/bin/missioncenter";
        };

        "hyprland/workspaces" = {
          active-only = false;
          format = "{windows}";
          format-window-separator = "";
          window-rewrite-default = "󱂬 ";
          window-rewrite = {
            "class<Tor Browser>" = "<span foreground='#${colors.base0E}' size='small'>﨩 </span>";
            "class<org.getmonero.>" = "<span foreground='#${colors.base0A}' size='small'> </span>";
            "class<Firefox - Personal>" = "<span foreground='#${colors.base0A}' size='small'>󰈹</span><span rise='6pt' size='xx-small'> b </span>";
            "class<Firefox - Services>" = "<span foreground='#${colors.base0C}' size='small'>󰈹</span><span rise='6pt' size='xx-small'> n </span>";
            "class<Firefox - Private>" = "<span foreground='#${colors.base0E}' size='small'>󰈹 </span>";
            "class<Chromium-browser>" = "<span foreground='#${colors.base0D}' size='small'></span><span rise='6pt' size='xx-small'> c </span>";
            "class<Chromium-browser> title<.*Microsoft Teams.*>" = "<span foreground='#${colors.base0D}' size='small'>󰊻</span><span rise='6pt' size='xx-small'> c </span>";
            "class<Chromium-browser> title<Outlook.*>" = "<span foreground='#${colors.base0D}' size='small'>󰴢</span><span rise='6pt' size='xx-small'> c </span>";
            "class<Chromium-browser> title<LINE>" = "<span foreground='#${colors.base0C}' size='small'>󰭻</span><span rise='6pt' size='xx-small'> c </span>";
            "class<whatsapp-for-linux>" = "<span foreground='#${colors.base0C}' size='small'> </span>";
            "class<FreeTube>" = "<span foreground='#${colors.base08}' size='small'>󰗃 </span>";
            "class<.*Youtube Music.*>" = "<span foreground='#${colors.base08}' size='small'>󰗃 </span>";
            "class<steam>" = "<span foreground='#${colors.base07}' size='small'>󰓓 </span>";
            "class<steam_app_.*>" = "<span foreground='#${colors.base07}' size='small'> </span>";
            "class<.gamescope-wrapped>" = "<span foreground='#${colors.base07}' size='small'>󰓓 </span>";
            "class<org.telegram.desktop>" = "<span foreground='#${colors.base0D}' size='small'> </span>";
            "class<Discord>" = "<span foreground='#${colors.base0D}' size='small'>󰙯 </span>";
            "class<Slack>" = "<span foreground='#${colors.base07}' size='small'>󰒱 </span>";
            "class<Mullvad VPN>" = "<span foreground='${colors.base0A}' size='small'>嬨</span>";
        
            "class<terminal>" = "<span size='small'> </span>";
            "class<neovim>" = "<span size='small'></span><span rise='6pt' size='xx-small'> v </span>";
            "class<org.keepassxc.KeePassXC>" ="<span size='small'></span><span rise='6pt' size='xx-small'> p </span>";
            "class<eog>" ="<span size='small'>  </span>";
            "class<org.fcitx.>" ="<span size='small'> </span>";
            "class<org.gnome.Nautilus>" ="<span size='small'> </span>";
            "class<evolution>" ="<span size='small'>󰇮</span><span rise='6pt' size='xx-small'> e </span>";
            "class<ONLYOFFICE Desktop Editors>" ="<span size='small'> </span>";
            "class<krita>" ="<span size='small'>󰏘 </span>";
            "class<vlc>" ="<span size='small'>嗢 </span>";
            "class<mpv>" ="<span size='small'>辶 </span>";
            "class<com.github.wwmm.easyeffects>" ="<span size='small'> </span>";
            "class<org.rncbc.qpwgraph>" ="<span size='small'> </span>";
            "class<dconf-editor>" ="<span size='small'>煉 </span>";
            "class<com.github.GradienceTeam.Gradience>" ="<span size='small'> </span>";
            "class<via-nativia>" ="<span size='small'> </span>";

            "class<re.sonny.Junction>" ="";

            "class<terminal-float>" ="";
            "class<btop>" ="";
            "class<pulsemixer>" ="";
            "class<bluetuith>" ="";
            "class<ncmpcpp>" ="";
            "class<hyprland-logs>" ="";
            "class<hyprland-socket>" ="";

            "class<Rofi>" ="";
            "class<powersupply>" ="";
            "class<io.missioncenter.MissionCenter>" ="";
            "class<pavucontrol>" ="";

            "class<org.gnome.Calendar>" ="";
          };

        };

      };

    };


  };

}
