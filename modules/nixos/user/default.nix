{ options, config, pkgs, lib, ... }:

with lib;
with lib.arclight;
let
  cfg = config.arclight.user;
  defaultIconFileName = "profile.jpg";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = { fileName = defaultIconFileName; };
  };

  propagatedIcon = pkgs.runCommandNoCC "propagated-icon"
    { passthru = { fileName = cfg.icon.fileName; }; }
    ''
      local target="$out/share/arclight-icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
in
{
  options.arclight.user = with types; {
    name = mkOpt str "jump" "The name to use for the user account.";
    fullName = mkOpt str "Jump" "Full name of the user.";
    description = mkOpt str "Jump" "Extra description of the user (is also display name on Gnome).";
    email = mkOpt str "waratch.p@outlook.com" "The email of the user.";
    initialPassword = mkOpt str "password"
      "The initial password to use when the user is first created.";
    icon = mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { }
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {

    environment.systemPackages = with pkgs; [
      propagatedIcon
    ];

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      histFile = "$XDG_CACHE_HOME/zsh/history";
    };

    arclight.home = {
      file = {
        "Desktop/.keep".text = "";
        "Documents/.keep".text = "";
        "Downloads/.keep".text = "";
        "Music/.keep".text = "";
        "Pictures/.keep".text = "";
        "Videos/.keep".text = "";
        "Repo/.keep".text = "";
        ".face".source = cfg.icon;
        "Pictures/${
        cfg.icon.fileName or (builtins.baseNameOf cfg.icon)
        }".source = cfg.icon;
      };

      extraOptions = {
        home.packages = with pkgs; [
          zsh-powerlevel10k
        ];

        programs = {

          zsh = {
            enable = true;
            enableCompletion = true;
            enableAutosuggestions = true;
            enableSyntaxHighlighting = true;

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
    };

    users.users.${cfg.name} = {
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.zsh;

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      uid = 1000;

      extraGroups = [ "wheel" "input" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
