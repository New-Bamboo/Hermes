function tags
  /usr/local/bin/ctags -R --exclude=.git --exclude=log --exclude=public --exclude='*.js' --exclude='*.coffee' --exclude=tmp -f ./.tags *
end
