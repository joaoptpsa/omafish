function tds --description 'tmux dev square: editor, diff watch, terminal, omarchy agent'
    # Usage: tds
    if test (count $argv) -gt 0
        echo "Usage: tds" >&2
        return 1
    end
    if not tmux display-message -p -t $TMUX_PANE &>/dev/null
        echo "You must start tmux to use tds." >&2
        return 1
    end

    set -l current_dir $PWD
    set -l editor_pane $TMUX_PANE

    tmux rename-window -t $editor_pane (basename $current_dir)

    # Four equal quadrants: editor top-left, diff top-right,
    # terminal bottom-left, agent bottom-right
    set -l terminal_pane (tmux split-window -v -p 50 -t $editor_pane -c $current_dir -P -F '#{pane_id}')
    set -l diff_pane (tmux split-window -h -p 50 -t $editor_pane -c $current_dir -P -F '#{pane_id}')
    set -l agent_pane (tmux split-window -h -p 50 -t $terminal_pane -c $current_dir -P -F '#{pane_id}')

    tmux send-keys -t $editor_pane "$EDITOR ." C-m
    tmux send-keys -t $diff_pane "hunk diff --watch" C-m
    tmux send-keys -t $agent_pane "omarchy-agent --inline" C-m

    tmux select-pane -t $editor_pane
end
