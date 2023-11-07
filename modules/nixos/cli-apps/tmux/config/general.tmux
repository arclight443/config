# Lower delay waiting for chord after escape key press.
set -g escape-time 0

# Change the prefix from C-b to C-s to make it easier to type.
set -g prefix C-Space
unbind C-b
bind C-Space send-prefix

# Start window numbers at 1 rather than 0.
 set -g base-index 1

# Use h, j, k, l for movement between panes.
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Fix colors being wrong in programs like Neovim.
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Expand the left status to accomodate longer session names.
set-option -g status-left-length 20

# One of the plugins binds C-l, make sure we have accces to it.
unbind C-l
bind -n C-l send-keys C-l

# Don't require a prompt to detach from the current session.
unbind -n M-E
bind -n M-E detach-client

# Reload tmux configuration from ~/.config/tmux/tmux.conf instead
# of Tilish's default of ~/.tmux.conf.
unbind -n M-C
bind -n M-C source-file "~/.config/tmux/tmux.conf"

# Use M-z to zoom and unzoom panes.
bind -n M-z resize-pane -Z

# Vi bindings in copy mode 
set-window-option -g mode-keys vi  # Prefix + [ to switch to copy mode, q returns to insert

# Clipboard
unbind -T copy-mode-vi Space; #Default for begin-selection
unbind -T copy-mode-vi Enter; #Default for copy-selection
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

# default statusbar colors
set-option -g status-style fg=yellow,bg=black #yellow and base02

# default window title colors
set-window-option -g window-status-style fg=brightblue,bg=default #base0 and default
#set-window-option -g window-status-style dim

# active window title colors
set-window-option -g window-status-current-style fg=brightred,bg=default #orange and default
#set-window-option -g window-status-current-style bright

# pane border
set-option -g pane-border-style fg=black #base02
set-option -g pane-active-border-style fg=brightgreen #base01

# message text
set-option -g message-style fg=brightred,bg=black #orange and base01

# pane number display
set-option -g display-panes-active-colour brightred #orange
set-option -g display-panes-colour blue #blue

# clock
set-window-option -g clock-mode-colour green #green

# bell
set-window-option -g window-status-bell-style fg=black,bg=red #base02, red

set -ga terminal-overrides ",xterm-256color:Tc"


