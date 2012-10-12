## Git PS1 prompt ##

function __fish_git_in_working_tree
  [ "true" = (git rev-parse --is-inside-work-tree ^ /dev/null; or echo false) ]
end

function __fish_git_dirty
  not git diff --no-ext-diff --quiet --exit-code ^ /dev/null
  or not git diff-index --cached --quiet HEAD ^ /dev/null
  or count (git ls-files --others --exclude-standard) > /dev/null
end

function __fish_git_current_head
  git symbolic-ref HEAD ^ /dev/null
  or git describe --contains --all HEAD
end

function __fish_git_current_branch
  __fish_git_current_head | sed -e "s#^refs/heads/##"
end

function prompt_git
  if __fish_git_in_working_tree
    if __fish_git_dirty
      set_color red
    else
      set_color blue
    end
    printf " %s%s" (__fish_git_current_branch) (set_color normal)
  end
end

function ggpull
  git pull origin (__fish_git_current_branch)
end

function ggpush
  git push origin (__fish_git_current_branch)
end
