function c --wraps=omarchy-agent --description 'Launch the omarchy default agent'
    if test (count $argv) -gt 0
        omarchy-agent-prompt --inline $argv
    else
        omarchy-agent --inline
    end
end
