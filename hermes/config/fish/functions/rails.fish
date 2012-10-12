function migrate
  bundle exec rake db:migrate db:test:prepare
end
