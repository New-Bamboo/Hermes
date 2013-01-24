function __find_logs
  find . -name '*.log'
end

function cleanlogs
  for file in (__find_logs)
    cat /dev/null > $file
  end
end
