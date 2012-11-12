function rvm -d 'Ruby enVironment Manager'
  # run RVM and capture the resulting environment
  set -l env_file (mktemp -t rvm.fish.XXXXXXXXXX)
  bash -c 'source ~/.rvm/scripts/rvm; rvm "$@"; status=$?; env > "$0"; exit $status' $env_file $argv

  # apply rvm_* and *PATH variables from the captured environment
  and eval (grep '^rvm\|^[^=]*PATH\|^GEM_HOME' $env_file | sed '/^[^=]*PATH/y/:/ /; s/^/set -xg /; s/=/ /; s/$/ ;/; s/(//; s/)//')
  set -xg MY_RUBY_HOME $GEM_HOME
  # clean up
  rm -f $env_file
end
