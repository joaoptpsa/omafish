function hdlm --description 'herdr dev layout per subdirectory, one tab each'
    # Usage: hdlm <c|cx|codex|other_ai> [<second_ai>]
    if test (count $argv) -eq 0
        echo "Usage: hdlm <c|cx|codex|other_ai> [<second_ai>]" >&2
        return 1
    end
    __herdr_require_pane hdlm || return 1

    set -l ai $argv[1]
    set -l ai2 $argv[2]
    set -l base_dir $PWD

    herdr workspace rename $HERDR_WORKSPACE_ID (basename $base_dir) >/dev/null

    # hdl runs in the new pane's shell, so the arguments need quoting there
    set -l hdl_command "hdl "(string escape -- $ai)
    test -n "$ai2" && set hdl_command "$hdl_command "(string escape -- $ai2)

    # find over a glob so an empty directory is silent rather than a wildcard error
    set -l first true
    for dirpath in (find $base_dir -mindepth 1 -maxdepth 1 -type d | sort)
        if test $first = true
            # Reuse the current tab for the first project
            herdr pane run $HERDR_PANE_ID "cd "(string escape -- $dirpath)" && $hdl_command" >/dev/null
            set first false
            continue
        end

        set -l pane_id (herdr tab create --workspace $HERDR_WORKSPACE_ID --cwd $dirpath --no-focus |
            jq -r '.result.root_pane.pane_id')
        herdr pane run $pane_id $hdl_command >/dev/null
    end
end
