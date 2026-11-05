function __herdr_require_pane --description 'Fail unless the caller runs inside a herdr pane'
    # herdr exports HERDR_PANE_ID into every pane it launches; its absence means
    # the layout helpers have no pane to split.
    test -n "$HERDR_PANE_ID" && return 0

    echo "You must start herdr to use $argv[1]." >&2
    return 1
end
