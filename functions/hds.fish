function hds --description 'herdr dev square: editor, diff watch, terminal, omarchy agent'
    # Usage: hds
    if test (count $argv) -gt 0
        echo "Usage: hds" >&2
        return 1
    end
    __herdr_require_pane hds || return 1

    set -l current_dir $PWD
    set -l editor_pane $HERDR_PANE_ID

    herdr tab rename $HERDR_TAB_ID (basename $current_dir) >/dev/null

    # Four equal quadrants: editor top-left, diff top-right,
    # terminal bottom-left, agent bottom-right
    set -l terminal_pane (__herdr_split $editor_pane down 0.5 $current_dir)
    set -l diff_pane (__herdr_split $editor_pane right 0.5 $current_dir)
    set -l agent_pane (__herdr_split $terminal_pane right 0.5 $current_dir)

    herdr pane run $editor_pane "$EDITOR ." >/dev/null
    herdr pane run $diff_pane "hunk diff --watch" >/dev/null
    herdr pane run $agent_pane "omarchy-agent --inline" >/dev/null
end
