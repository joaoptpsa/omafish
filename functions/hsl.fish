function hsl --description 'herdr swarm layout: N tiled panes all running one command'
    # Usage: hsl <pane_count> <command>
    if test (count $argv) -lt 2
        echo "Usage: hsl <pane_count> <command>" >&2
        return 1
    end
    __herdr_require_pane hsl || return 1

    set -l count $argv[1]
    set -l cmd $argv[2]
    set -l current_dir $PWD

    herdr tab rename $HERDR_TAB_ID (basename $current_dir) >/dev/null

    # Square-ish grid: ceil(sqrt(count)) columns
    set -l cols 1
    while test (math "$cols * $cols") -lt $count
        set cols (math $cols + 1)
    end

    # Peeling the rightmost column off at 1/(remaining) keeps widths even and
    # the list in left-to-right order
    set -l columns $HERDR_PANE_ID
    for k in (seq 1 (math $cols - 1))
        set -l denom (math $cols - $k + 1)
        set -a columns (__herdr_split $columns[-1] right (math -s4 "1 / $denom") $current_dir)
    end

    # Each column takes its share of rows, remainder spread over the leftmost
    set -l panes
    for index in (seq 1 $cols)
        set -l rows (math "floor($count / $cols)")
        test (math $index - 1) -lt (math "$count % $cols") && set rows (math $rows + 1)

        set -l last $columns[$index]
        set -a panes $last
        for j in (seq 1 (math $rows - 1))
            set -l denom (math $rows - $j + 1)
            set last (__herdr_split $last down (math -s4 "1 / $denom") $current_dir)
            set -a panes $last
        end
    end

    for pane in $panes
        herdr pane run $pane $cmd >/dev/null
    end
end
