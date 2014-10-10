if exists("g:loaded_vimux_elixir_test") || &cp
  finish
endif
let g:loaded_vimux_elixir_test = 1

if !has("ruby")
  finish
end

command RunExunitTests :call s:RunExunitTests()
command RunExunitFocusedTest :call s:RunExunitFocusedTest()

function s:RunExunitTests()
  ruby Elixir.new.run
endfunction

function s:RunExunitFocusedTest()
  ruby Elixir.new.run_focused
endfunction

ruby << EOF
module VIM
  class Buffer
    def method_missing(method, *args, &block)
      VIM.command "#{method} #{self.name}"
    end
  end
end

class Elixir
  def current_file
    VIM::Buffer.current.name
  end

  def current_line
    VIM::Buffer.current.line_number
  end

  def module_name
    current_file.split("/").last.split(".").first[0...-6]
  end

  def run
    send_to_vimux("#{test_command} #{current_file}")
  end

  def run_focused
    send_to_vimux("#{test_command} #{current_file}:#{current_line}")
  end

  def test_command
    "mix test"
  end

  def send_to_vimux(test_command)
    Vim.command("call VimuxRunCommand(\"clear && #{test_command}\")")
  end
end
EOF
