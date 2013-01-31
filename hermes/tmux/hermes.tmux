set -g status-left-length 32
set -g status-right-length 150

set -g status-fg white
set -g status-bg colour235
set -g window-status-activity-attr bold
set -g pane-border-fg colour250
set -g pane-active-border-fg colour210
set -g message-fg colour16
set -g message-bg colour221
set -g message-attr bold

set -g status-left '#[fg=colour245] #S'
set -g window-status-format "#[fg=white,bg=colour235] #I #W "
set -g window-status-current-format "#[bg=colour203,fg=colour233,noreverse,bold] #I #W #[fg=colour39,bg=colour234,nobold]"
set -g status-right '#[fg=colour39] #(battery-life) #(battery-time) #[fg=colour203] #(date +"%a, %b %d %Y - %H:%M ")'
