function mark() {
  if [ $1 ]
  then open -a Marked\ 2.app $1
  else open -a Marked\ 2.app
  fi
}
