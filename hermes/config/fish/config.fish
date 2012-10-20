if status --is-login

  for p in /usr/local/bin /usr/local/sbin /usr/local/share/npm/bin /usr/bin /opt/local/bin ~/.hermes/hermes/bin
    if test -d $p
      set PATH $p $PATH
    end
  end

  # script that needs to start once per fishd session
  if test $RUNNING_TMUX_COPY == false
    tmux_copy &
    set -U RUNNING_TMUX_COPY true
  end

end

. functions/*.fish

set fish_greeting ""
set -x CLICOLOR 1
set -u EDITOR /usr/local/bin/vim
set -u NODE_PATH /usr/local/lib/node

rvm reload > /dev/null
autojump   > /dev/null

function rehash
  . ~/.config/fish/config.fish
end

function flush
  dscacheutil -flushcache
end

function fish_prompt -d "Write out the prompt"
# printf '%s%s@%s%s' (set_color brown) (whoami) (hostname|cut -d . -f 1) (set_color normal)

# Color writeable dirs green, read-only dirs red
if test -w "."
  printf '%s%s' (set_color brown) (prompt_pwd)
else
  printf '%s%s' (set_color red) (prompt_pwd)
end

# Print git branch
if test -d ".git"
  prompt_git
end

printf ' %s%s%s ± %s' (set_color green) (rvm-prompt v) (set_color brown) (set_color normal)

end
