if exists("g:loaded_vimux_erlang_test") || &cp
  finish
endif
let g:loaded_vimux_erlang_test = 1

if !has("ruby")
  finish
end

command RunEunitTests :call s:RunEunitTests()

function s:RunEunitTests()
  ruby Erlang.new.run
endfunction

ruby << EOF
module VIM
  class Buffer
    def method_missing(method, *args, &block)
      VIM.command "#{method} #{self.name}"
    end
  end
end

class Erlang
  def current_file
    VIM::Buffer.current.name
  end

  def module_name
    current_file.split("/").last.split(".").first[0...-6]
  end

  def run
    send_to_vimux("#{test_command} suite=#{module_name}")
  end

  def test_command
    "rebar eunit"
  end

  def send_to_vimux(test_command)
    Vim.command("call VimuxRunCommand(\"clear && #{test_command}\")")
  end
end
EOF
