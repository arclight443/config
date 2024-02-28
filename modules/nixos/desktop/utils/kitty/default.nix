{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.kitty;
  colors = inputs.nix-colors.colorSchemes."${config.arclight.colorscheme.theme}".palette;
  gnome-terminal-spoof = pkgs.writeShellScriptBin "gnome-terminal" ''
    ${pkgs.kitty}/bin/kitty $@
  '';
in
{
  options.arclight.desktop.utils.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to enable kitty terminal.";
  };

  config = mkIf cfg.enable {
    
    arclight.home.extraOptions = {
      home.packages = [] ++ optional config.arclight.desktop.gnome.enable gnome-terminal-spoof;

      programs.kitty = {
        enable = true;
        shellIntegration = {
          enableZshIntegration = true;
        };

        font = {
          name = "MesloLGS NF";
          package = pkgs.meslo-lgs-nf;
          size = if config.arclight.desktop.gnome.enable then 16.5 else 11.5;
        };

        keybindings = {
          "ctrl+shift+v" = "paste_from_clipboard";
          "ctrl+shift+c" = "copy_to_clipboard";
          "shift+insert" = "paste_from_clipboard";

          "ctrl+shift+k" = "scroll_line_up";
          "ctrl+shift+j" = "scroll_line_down";

          "ctrl+shift+up" = "increase_font_size";
          "ctrl+shift+down" = "decrease_font_size";
          "ctrl+shift+backspace" = "restore_font_size";
        };

        settings = {
          #include = "${pkgs.arclight.gruvbox-flat-nvim-extras}/extras/kitty_gruvbox_.conf";
          background = if config.arclight.colorscheme.oled then "#000000" else "#${colors.base00}";
          foreground = "#${colors.base05}";
          selection_background = "#${colors.base01}";
          selection_foreground = "#${colors.base05}";
          url_color = "#${colors.base0B}";
          cursor = "#${colors.base05}";

          active_tab_background = "#${colors.base09}";
          active_tab_foreground = "#${colors.base00}";
          inactive_tab_background = "#${colors.base01}";
          inactive_tab_foreground = "#${colors.base05}";

          color0 = "#${colors.base00}";
          color1 = "#${colors.base08}";
          color2 = "#${colors.base0B}";
          color3 = "#${colors.base0A}";
          color4 = "#${colors.base0D}";
          color5 = "#${colors.base0E}";
          color6 = "#${colors.base0C}";
          color7 = "#${colors.base05}";

          color8 = "#${colors.base03}";
          color9 = "#${colors.base09}";
          color10 = "#${colors.base0B}";
          color11 = "#${colors.base0A}";
          color12 = "#${colors.base0D}";
          color13 = "#${colors.base0E}";
          color14 = "#${colors.base0C}";
          color15 = "#${colors.base05}";
          
          color16 = "#${colors.base09}";
          color17 = "#${colors.base08}";
          
          background_opacity = if config.arclight.colorscheme.oled then "1" else "0.8";

          remember_window_size = "no";
          placement_strategy = "top-left";
          window_border_width = 6;
          window_margin_width = 6;

          clipboard_control = "write-primary write-clipboard no-append";
          select_by_word_characters = ":@-./_~?&=%+#";
          confirm_os_window_close = 0;
          scrollback_lines = 10000;
          hide_window_decorations = true;
          enable_audio_bell = false;
        };
      };
    };

  };
}
