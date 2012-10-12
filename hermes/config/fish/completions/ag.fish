function __get_ag_completion -d "Create ag completions"

  if test -f .tags
    cut -f 1 .tags | uniq | grep -v '!_'
  end

end

complete -x -c ag -a "(__get_ag_completion)"
