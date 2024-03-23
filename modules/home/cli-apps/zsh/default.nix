{ options, config, lib, pkgs, ... }:

with lib;
with lib.arclight;
let cfg = config.arclight.cli-apps.zsh;
in
{
  options.arclight.cli-apps.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to enable zsh.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      zsh-powerlevel10k
    ];

    programs = {

      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;

        initExtraBeforeCompInit = ''
          # Enable PowerLevel10k instant prompt.
          P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
          [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
        '';

        completionInit = ''
          autoload bashcompinit && bashcompinit
          autoload -Uz compinit && compinit
        '';

        initExtra = ''

          # Completions
          zmodload zsh/complist
          bindkey -M menuselect 'h' vi-backward-char
          bindkey -M menuselect 'k' vi-up-line-or-history
          bindkey -M menuselect 'j' vi-down-line-or-history
          bindkey -M menuselect 'l' vi-forward-char
          bindkey -M menuselect '^xg' clear-screen
          bindkey -M menuselect '^xi' vi-insert                      # Insert
          bindkey -M menuselect '^xh' accept-and-hold                # Hold
          bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
          bindkey -M menuselect '^xu' undo                           # Undo

          # Options
          setopt AUTO_CD
          setopt COMBINING_CHARS
          setopt NO_BEEP
          setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
          setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
          setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

          # Zstyle
          zstyle ':completion:*' completer _extensions _complete _approximate
          zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
          zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
          zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
          zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
          zstyle ':completion:*:*:*:*:default' list-colors ''${(s.:.)LS_COLORS}
          
          zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
          zstyle ':completion:*' group-name ' '
          zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

          zstyle ':completion:*' menu select
          zstyle ':completion:*' squeeze-slashes true
          zstyle ':completion:*' complete-options true

          zstyle ':completion:*' matcher-list ' '  'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
          zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(''${=''${''${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
          zstyle ':completion:*' keep-prefix true

          # Fix an issue with tmux.
          export KEYTIMEOUT=1


          # Use vim bindings.
          set -o vi

          # Improved vim bindings.
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        '';

        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.arclight.zsh-nix-shell;
          }
          {
            name = "powerlevel10k";
            file = "powerlevel10k.zsh-theme";
            src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
          }
          {
            name = "powerlevel10k-config";
            file = "p10k.zsh";
            src = ./p10k-config;
          }
        ];

      };

    };

  };
}
