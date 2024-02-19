{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.desktop.utils.kitty;
in
{
  options.arclight.desktop.utils.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to enable kitty terminal.";
  };

  config = mkIf cfg.enable {
    
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
      };

      font = {
        name = "MesloLGS NF";
        package = pkgs.meslo-lgs-nf;
        size = 11.5;
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
        include = "${pkgs.arclight.gruvbox-flat-nvim-extras}/extras/kitty_gruvbox_.conf";
        background_opacity = "0.8";

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
}
