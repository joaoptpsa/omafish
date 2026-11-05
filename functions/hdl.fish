function hdl --description 'herdr dev layout: editor left, ai right, terminal below'
    # Usage: hdl <c|cx|codex|other_ai> [<second_ai>]
    if test (count $argv) -eq 0
        echo "Usage: hdl <c|cx|codex|other_ai> [<second_ai>]" >&2
        return 1
    end
    __herdr_require_pane hdl || return 1

    set -l current_dir $PWD
    set -l ai $argv[1]
    set -l ai2 $argv[2]

    # HERDR_PANE_ID stays valid even if focus moves mid-layout
    set -l editor_pane $HERDR_PANE_ID

    herdr tab rename $HERDR_TAB_ID (basename $current_dir) >/dev/null

    # Terminal strip along the bottom, editor keeps the top 85%
    __herdr_split $editor_pane down 0.85 $current_dir >/dev/null

    # AI takes the right 30% of what the editor kept
    set -l ai_pane (__herdr_split $editor_pane right 0.7 $current_dir)

    if test -n "$ai2"
        set -l ai2_pane (__herdr_split $ai_pane down 0.5 $current_dir)
        herdr pane run $ai2_pane $ai2 >/dev/null
    end

    herdr pane run $ai_pane $ai >/dev/null
    herdr pane run $editor_pane "$EDITOR ." >/dev/null
end
