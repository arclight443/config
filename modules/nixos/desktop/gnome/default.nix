{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.gnome;
  gdmHome = config.users.users.gdm.home;
  dotfiles = "/home/${config.arclight.user.name}/Arclight/dotfiles";
  terminal = if       config.arclight.desktop.utils.kitty.enable then "kitty"
             else if  config.arclight.desktop.utils.alacritty.enable then "alacritty"
             else "";

  defaultExtensions = with pkgs.gnomeExtensions; [
    just-perfection
    blur-my-shell
    top-bar-organizer
    run-or-raise
    logo-menu
    kimpanel
    dash-to-dock
    quick-settings-tweaker
    wallpaper-slideshow
    gsconnect
    paperwm
    vitals
  ] 
    ++ optionals config.arclight.hardware.laptop.tabletpc.enable
  [ 
    pkgs.gnomeExtensions.touch-x 
    pkgs.gnomeExtensions.screen-rotate 
  ];

  reloadRaise = pkgs.writeShellApplication {
    name = "reload-raise";
    checkPhase = "";
    runtimeInputs = [];
    text = ''
      ${pkgs.gnome.gnome-shell}/bin/gnome-extensions disable run-or-raise@edvard.cz;
      ${pkgs.gnome.gnome-shell}/bin/gnome-extensions enable run-or-raise@edvard.cz;
      ${pkgs.libnotify}/bin/notify-send "Run-or-raise" "Reloaded";
    '';
  };

  default-attrs = mapAttrs (key: mkDefault);
  nested-default-attrs = mapAttrs (key: default-attrs);
in
{
  options.arclight.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    suspend = mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    extensions = mkOpt (listOf package) [ ] "Extra Gnome extensions to install.";
  };

  config = mkIf cfg.enable {
    arclight.system.xkb.enable = true;
    arclight.desktop.utils = {
      common = enabled;
      gtk = enabled;
      qt = enabled;
      electron-support = enabled;
      alacritty = enabled;
      ibus = enabled;
      nautilus = enabled;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      gtk-engine-murrine
      qgnomeplatform
      gnome.seahorse
      gnome.gnome-themes-extra
      gnome.gnome-tweaks
      gnome.zenity
    ] ++ defaultExtensions ++ cfg.extensions ++ [ reloadRaise ]
      ++ optional config.arclight.security.yubikey.enable pkgs.arclight.gnome-lock-all-sessions;

    environment.gnome.excludePackages = with pkgs.gnome; [
      gnome-terminal
      pkgs.gnome-console
      pkgs.gnome-tour
      pkgs.gnome-photos
      pkgs.gnome-connections
      pkgs.font-manager
      totem
      yelp
      gnome-music
      epiphany
      geary
      gnome-contacts
      gnome-characters
      gnome-font-viewer
      gnome-maps
      gnome-system-monitor
    ];

    systemd.services.arclight-user-icon = {
      before = [ "display-manager.service" ];
      wantedBy = [ "display-manager.service" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
      };

      script = ''
        config_file=/var/lib/AccountsService/users/${config.arclight.user.name}
        icon_file=/run/current-system/sw/share/arclight-icons/user/${config.arclight.user.name}/${config.arclight.user.icon.fileName}

        if ! [ -d "$(dirname "$config_file")"]; then
          mkdir -p "$(dirname "$config_file")"
        fi

        if ! [ -f "$config_file" ]; then
          echo "[User]
          Session=gnome
          SystemAccount=false
          Icon=$icon_file" > "$config_file"
        else
          icon_config=$(sed -E -n -e "/Icon=.*/p" $config_file)

          if [[ "$icon_config" == "" ]]; then
            echo "Icon=$icon_file" >> $config_file
          else
            sed -E -i -e "s#^Icon=.*$#Icon=$icon_file#" $config_file
          fi
        fi
      '';
    };

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
    
    # TODO Lock screen on Yubikey removal. Sometimes don't work. Maybe udev priority issue?
    #services.udev.extraRules = if config.arclight.security.yubikey.enable then ''
    #      ACTION=="remove", SUBSYSTEM=="usb", ENV{ID_MODEL_FROM_DATABASE}=="Yubikey 4/5 OTP+U2F+CCID", RUN+="${pkgs.arclight.gnome-lock-all-sessions}/bin/gnome-lock-all-sessions"
    #  '' else "";

    services.xserver = {
      enable = true;

      libinput.enable = true;

      displayManager = {

        gdm = {
          enable = true;
          wayland = true;
          autoSuspend = cfg.suspend;
          settings = {
            greeter = {
              IncludeAll = false;
              Exclude = "root";
            };
            #daemon = {
            #  AutomaticLoginEnable = true;
            #  AutomaticLogin = config.arclight.user.name;
            #};
          };
        };
      };

      desktopManager.gnome.enable = true;
    };
    
    security.pam.services.login.enableGnomeKeyring = true;
    
    home-manager.users.${config.arclight.user.name} = { config, pkgs, ... }: {

      xdg.configFile = {
        "run-or-raise".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/run-or-raise";
        "paperwm/user.css".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/paperwm/user.css";
      };

      home.file = {
        ".themes/".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/shell-themes/";
      };

    };

    arclight.home.extraOptions = { lib, ... }: {

      dconf.settings =
        let
          user = config.users.users.${config.arclight.user.name};
          mkTuple = lib.hm.gvariant.mkTuple;
          mkUint32 = lib.hm.gvariant.mkUint32;
        in
        nested-default-attrs {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = (builtins.map (extension: extension.extensionUuid) (cfg.extensions ++ defaultExtensions))
              ++ [
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
            ];
            favorite-apps =
              [ "org.gnome.Nautilus.desktop" ]
              ++ optional config.arclight.apps.evolution.enable "evolution.desktop"
              ++ optional config.arclight.desktop.utils.kitty.enable "kitty.desktop"
              ++ optional config.arclight.desktop.utils.alacritty.enable "Alacritty.desktop"
              ++ optional config.arclight.browsers.firefox.profiles.personal.enable "firefox.desktop"
              ++ optional config.arclight.browsers.firefox.profiles.services.enable "firefox-services.desktop"
              ++ optional config.arclight.browsers.firefox.profiles.discord.enable "firefox-discord.desktop"
              ++ optional config.arclight.apps.telegram.enable "org.telegram.desktop.desktop"
              ++ optional config.arclight.apps.fractal.enable "org.gnome.Fractal.desktop"
              ++ optional config.arclight.apps.steam.enable "steam.desktop";
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            screensaver = [ "<Shift><Control>l" ];
          };

          "org/gnome/desktop/sound" = {
            allow-volume-above-100-percent = true;
          };

          "org/gnome/desktop/input-sources" = {
            sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "th" ]) (mkTuple [ "ibus" "mozc-jp" ]) ];
          };

          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            clock-show-weekday = true;
            text-scaling-factor = 1.00;
            cursor-size = 42;
            font-name = "Source Sans 3 Regular 16";
            monospace-font-name = "MesloLGS NF Regular 11";
            document-font-name = "Kanit Regular 14";
            show-battery-percentage = false;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            edge-scrolling-enabled = false;
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
            disable-while-typing = false;
          };

          "org/gnome/desktop/peripherals/keyboard" = {
            delay = mkUint32 220;
            repeat = true;
            repeat-interval = mkUint32 20;
          };

          "org/gnome/desktop/wm/preferences" = {
            #num-workspaces = 10;
            focus-mode = "click";
            button-layout = "appmenu:close";
            titlebar-font = "Source Sans 3 Regular 12";
          };

          "org/gnome/desktop/wm/keybindings" = {
            #close = [ "<Super>q" ];
            maximize = [ ];
            minimize = [ ];
            #toggle-maximized = [ "<Super>f" ];

            switch-group                  = [ ];
            switch-group-backward         = [ ];
            #switch-applications           = [ "<Super>Tab" ];
            #switch-applications-backward  = [ "<Super><Shift>Tab" ];
            switch-panels                 = [ ];
            switch-panels-backward        = [ ];

            switch-to-workspace-1         = [ ];
            switch-to-workspace-2         = [ ];
            switch-to-workspace-3         = [ ];
            switch-to-workspace-4         = [ ];
            switch-to-workspace-5         = [ ];
            switch-to-workspace-6         = [ ];
            switch-to-workspace-7         = [ ];
            switch-to-workspace-8         = [ ];
            switch-to-workspace-9         = [ ];
            switch-to-workspace-10        = [ ];
            switch-to-workspace-left      = [ ];
            switch-to-workspace-right     = [ ];

            move-to-workspace-1           = [ ];
            move-to-workspace-2           = [ ];
            move-to-workspace-3           = [ ];
            move-to-workspace-4           = [ ];
            move-to-workspace-5           = [ ];
            move-to-workspace-6           = [ ];
            move-to-workspace-7           = [ ];
            move-to-workspace-8           = [ ];
            move-to-workspace-9           = [ ];
            move-to-workspace-10          = [ ];
            move-to-workspace-left        = [ ];
            move-to-workspace-right       = [ ];

            #switch-to-workspace-1         = [ "<Super>1" ];
            #switch-to-workspace-2         = [ "<Super>2" ];
            #switch-to-workspace-3         = [ "<Super>3" ];
            #switch-to-workspace-4         = [ "<Super>4" ];
            #switch-to-workspace-5         = [ "<Super>5" ];
            #switch-to-workspace-6         = [ "<Super>6" ];
            #switch-to-workspace-7         = [ "<Super>7" ];
            #switch-to-workspace-8         = [ "<Super>8" ];
            #switch-to-workspace-9         = [ "<Super>9" ];
            #switch-to-workspace-10        = [ "<Super>0" ];
            #switch-to-workspace-left      = [ "<Super>braceleft" ];
            #switch-to-workspace-right     = [ "<Super>braceright" ];

            #move-to-workspace-1           = [ "<Shift><Super>1" ];
            #move-to-workspace-2           = [ "<Shift><Super>2" ];
            #move-to-workspace-3           = [ "<Shift><Super>3" ];
            #move-to-workspace-4           = [ "<Shift><Super>4" ];
            #move-to-workspace-5           = [ "<Shift><Super>5" ];
            #move-to-workspace-6           = [ "<Shift><Super>6" ];
            #move-to-workspace-7           = [ "<Shift><Super>7" ];
            #move-to-workspace-8           = [ "<Shift><Super>8" ];
            #move-to-workspace-9           = [ "<Shift><Super>9" ];
            #move-to-workspace-10          = [ "<Shift><Super>0" ];
            #move-to-workspace-left        = [ "<Shift><Super>braceleft" ];
            #move-to-workspace-right       = [ "<Shift><Super>braceright" ];

            #move-to-monitor-down          = [ "<Super><Alt>j" ];
            #move-to-monitor-left          = [ "<Super><Alt>h" ];
            #move-to-monitor-right         = [ "<Super><Alt>l" ];
            #move-to-monitor-up            = [ "<Super><Alt>k" ];

            switch-input-source          = [ "<Super>space" ];
            switch-input-source-backward = [ "<Shift><Super>space" ];
          };

          "org/gnome/shell/keybindings" = {
            switch-to-application-1       = [ ];
            switch-to-application-2       = [ ];
            switch-to-application-3       = [ ];
            switch-to-application-4       = [ ];
            switch-to-application-5       = [ ];
            switch-to-application-6       = [ ];
            switch-to-application-7       = [ ];
            switch-to-application-8       = [ ];
            switch-to-application-9       = [ ];
            switch-to-application-10      = [ ];

            shift-overview-down           = [ ];
            shift-overview-up             = [ ];
            open-application-menu         = [ ];

            toggle-overview               = [ "<Super>d" ];
            toggle-application-view       = [ ];
            toggle-quick-settings         = [ "<Super>apostrophe" ];
            toggle-message-tray           = [ "<Super><Shift>apostrophe" ];
            focus-active-notification     = [ "<Super>escape" ];

            show-screenshot-ui            = [ "Print" ];
            show-screen-recording-ui      = [ "<Ctrl><Shift><Super>R" ];
            screenshot                    = [ "<Shift>Print" ];
            screenshot-window             = [ "<Super>Print" ];
          };

          "org/gnome/mutter" = {
            edge-tiling = false;
            dynamic-workspaces = true;
            workspaces-only-on-primary = false;
            attach-modal-dialogs = false;
            overlay-key = "";
            center-new-windows = true;
            #experimental-features = [ "scale-monitor-framebuffer" ];
          };

          "org/gnome/wayland/keybindings" = {
            restore-shortcuts = [ ];
          };

          "org/gnome/shell/extensions/user-theme" = {
            name = "Adwaita-Dark-Gruvbox";
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            always-center-icons = true;
            apply-custom-theme = false;
            autohide = true;
            autohide-in-fullscreen = false;
            background-color = "rgb(40,40,40)";
            background-opacity = 0.8;
            custom-background-color = true;
            custom-theme-shrink = true;
            customize-alphas = true;
            dash-max-icon-size = 64;
            dock-fixed = false;
            dock-position = "BOTTOM";
            extend-height = false;
            height-fraction = 0.9;
            hot-keys = false;
            intellihide = false;
            isolate-monitors = false;
            isolate-workspaces = false;
            min-alpha = 0.6;
            max-alpha = 0.9;
            multi-monitor = true;
            pressure-threshold = 100;
            preview-size-scale = 1.0;
            running-indicator-style = "DOTS";
            show-icon-emblems = false;
            transparency-mode = "DYNAMIC";
          };

          "org/gnome/shell/extensions/quick-settings-tweaks" = {
            add-dnd-quick-toggle-enabled = true;
            add-unsafe-quick-toggle-enabled = false;
            input-always-show = false;
            input-show-selected = true;
            last-unsafe-state = false;
            media-control-compact-mode = false;
            media-control-enabled = true;
            output-show-selected = true;
            user-removed-buttons = [ "DarkModeToggle" "NMVpnToggle" ];
            volume-mixer-enabled = true;
            volume-mixer-position = "bottom";
            volume-mixer-show-description = false;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            startup-status = 0;
            app-menu = false;
            panel-in-overview = true;
            activities-button = false;
            calendar = true;
            clock-menu = true;
            events-button = true;
            weather = true;
            world-clock = false;
            workspace = true;
            workspace-popup = false;
            workspaces-in-app-grid = false;
            window-demands-attention-focus = true;
            ripple-box = true;
            quick-settings = true;
            power-icon = true;
            
            looking-glass-height = 8;
            looking-glass-width = 8;
            #panel-button-padding-size = 6;
            #panel-corner-size = 0;
            #panel-icon-size = 15;
            #panel-indicator-padding-size = 1;
            #panel-size = 0;
          };

          "org/gnome/shell/extensions/azwallpaper" = {
            slideshow-directory = "/home/${config.arclight.user.name}/Arclight/dotfiles/wallpaper/birb";
            slideshow-slide-duration = mkTuple [ 1 0 0 ];
          };

          "org/gnome/shell/extensions/blur-my-shell" = {
            brightness = 0.70;
          };

          "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
            blur = true;
          };

          "org/gnome/shell/extensions/blur-my-shell/applications" = {
            blur = false;
            brightness = 0.6;
            customize = true;
            opacity = 255;
            sigma = 10;
          };

          "org/gnome/shell/extensions/blur-my-shell/overview" = {
            blur = true;
          };

          "org/gnome/shell/extensions/blur-my-shell/panel" = {
            blur = false;
          };

          "org/gnome/shell/extensions/paperwm" = {
            vertical-margin = 4;
            vertical-margin-bottom = 0;
            window-gap = 12;
            minimap-scale = 0.15;

            animation-time = 0.12;
            cycle-width-steps = [ 750.0 1130.0 ];
            horizontal-margin = 10;

            disable-scratch-in-overview = false;
            disable-top-bar-styling = false;
            gesture-enabled = true;
            only-scratch-in-overview = false;
            restore-attach-modal-dialogs = false;
            restore-edge-tiling = false;
            restore-workspaces-only-on-primary = false;
            show-focus-mode-icon = true;
            show-window-position-bar = true;
            show-workspace-indicator = true;
            use-default-background = true;

            winprops = [
              "{\"wm_class\":\"org.gnome.Calculator\", \"title\":\"\", \"scratch_layer\":true}"
              "{\"wm_class\":\"evolution\", \"title\":\"\", \"preferredWidth\":\"80%\"}"
              "{\"wm_class\":\"KeePassXC\", \"title\":\"\", \"preferredWidth\":\"80%\"}"
              "{\"wm_class\":\"\", \"title\":\"terminal-ncmpcpp\", \"preferredWidth\":\"80%\"}"
              "{\"wm_class\":\"\", \"title\":\"terminal-bluetuith\", \"preferredWidth\":\"80%\"}"
              "{\"wm_class\":\"\", \"title\":\"terminal-neovim\", \"preferredWidth\":\"60%\"}"
              "{\"wm_class\":\"\", \"title\":\"terminal-pulsemixer\", \"preferredWidth\":\"60%\"}"
              "{\"wm_class\":\"\", \"title\":\"terminal-btop\", \"preferredWidth\":\"100%\"}"
            ];

          };

          "org/gnome/shell/extensions/paperwm/keybindings" = {

            close-window                            = [ "<Super>q" ];
            new-window                              = [ "" ];

            switch-left                             = [ "" ];
            switch-down                             = [ "" ];
            switch-up                               = [ "" ];
            switch-right                            = [ "" ];
            switch-global-left                      = [ "<Super>h" ];
            switch-global-down                      = [ "<Super>j" ];
            switch-global-up                        = [ "<Super>k" ];
            switch-global-right                     = [ "<Super>l" ];
            switch-down-workspace                   = [ "" ];
            switch-up-workspace                     = [ "" ];
            switch-down-workspace-from-all-monitors = [ "<Super>braceright" ];
            switch-up-workspace-from-all-monitors   = [ "<Super>braceleft"  ];
            switch-next                             = [ "" ];
            switch-previous                         = [ "" ];
            switch-first                            = [ "" ];
            switch-last                             = [ "" ];

            switch-monitor-below                    = [ "<Control><Super>j" ];
            switch-monitor-left                     = [ "<Control><Super>h" ];
            switch-monitor-right                    = [ "<Control><Super>l" ];
            switch-monitor-above                    = [ "<Control><Super>k" ];
            switch-monitor-up                       = [ "" ];
            switch-monitor-down                     = [ "" ];
            switch-focus-mode                       = [ "<Shift><Super>c" ];
            center-horizontal                       = [ "<Super>c" ];

            move-left                               = [ "<Shift><Super>h" ];
            move-down                               = [ "<Shift><Super>j" ];
            move-up                                 = [ "<Shift><Super>k" ];
            move-right                              = [ "<Shift><Super>l" ];
            move-down-workspace                     = [ "<Shift><Super>braceright" ];
            move-up-workspace                       = [ "<Shift><Super>braceleft" ];

            move-monitor-above                      = [ "<Shift><Control><Super>k" ];
            move-monitor-below                      = [ "<Shift><Control><Super>j" ];
            move-monitor-down                       = [ "<Shift><Control><Super>j" ];
            move-monitor-left                       = [ "<Shift><Control><Super>h" ];
            move-monitor-right                      = [ "<Shift><Control><Super>l" ];
            move-monitor-up                         = [ "<Shift><Control><Super>k" ];
            move-next                               = [ "" ];
            move-previous                           = [ "" ];

            swap-monitor-down                       = [ "" ];
            swap-monitor-left                       = [ "<Alt><Super>h" ];
            swap-monitor-right                      = [ "<Alt><Super>l" ];
            swap-monitor-up                         = [ "" ];
            swap-monitor-above                      = [ "<Alt><Super>k" ];
            swap-monitor-below                      = [ "<Alt><Super>j" ];

            toggle-scratch                          = [ "<Shift><Super><Ctrl>f" ];
            toggle-scratch-layer                    = [ "" ];
            toggle-scratch-window                   = [ "" ];

            take-window                             = [ "" ];

          };

          "org/gnome/shell/extensions/vitals" = {
            fixed-widths = true;
            hide-icons = false;
            hide-zeros = false;
            include-static-info = true;
            monitor-cmd = "missioncenter";
            position-in-panel = 0;
            show-battery = true;
            show-fan = false;
            use-higher-precision = false;
            hot-sensors = "['_memory_usage_', '__network-rx_max__', '__temperature_avg__']";
          };

          "org/gnome/shell/extensions/touchx" = {
            ripple = false;
            bgcolor = ["0.9215686321258545" "0.8588235378265381" "0.6980392336845398"];
            oskbtn = true;
            radius = 30;
            time = 3;
          };

          "org/gnome/shell/extensions/top-bar-organizer" = {
            left-box-order = [
              "menuButton"
              "activities"
              "appMenu"
              "LogoMenu"
              "vitalsMenu"
            ];

            center-box-order = [ 
              "FocusButton"
              "WorkspaceMenu"
            ];

            right-box-order = [
              "kimpanel"
              "a11y"
              "keyboard"
              "drive-menu"
              "screenRecording"
              "screenSharing"
              "dwellClick"
              "quickSettings"
              "dateMenu"
            ];
          };

          "org/gnome/shell/extensions/Logo-menu" = {
            hide-softwarecentre = true;
            hide-forcequit = true;
            menu-button-extensions-app = "org.gnome.Extensions.desktop";
            menu-button-icon-click-type = "3";
            menu-button-icon-image = 23;
            menu-button-icon-size = 25;
            menu-button-terminal = terminal;
          };

          "ca/desrt/dconf-editor" = {
            show-warning = false;
          };

        };
    };

  };
}

