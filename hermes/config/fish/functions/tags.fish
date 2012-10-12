function tags
  /usr/local/bin/ctags -R --exclude=.git --exclude=log --exclude=public --exclude=tmp -f ./.tags *
end
