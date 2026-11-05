# Exported environment variables belong in the canonical source ~/.shell/envs (bash) sourced at login by ~/.shell/login.
# Fish inherits those values from the login environment, so a re-login (or reboot) is required.

set -g fish_greeting

# History configuration - match bash HISTSIZE
set -g fish_history_max_size 32768

# XDG Base Directory Specification
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME "$HOME/.cache"
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME "$HOME/.local/state"
set -q XDG_PICTURES; or set -gx XDG_PICTURES "$HOME/Pictures"
set -q XDG_SCREENSHOTS_DIR; or set -gx XDG_SCREENSHOTS_DIR "$HOME/Pictures/Screenshots"
set -q XDG_CONFIG_DIRS; or set -gx XDG_CONFIG_DIRS /etc/xdg
set -q XDG_DATA_DIRS; or set -gx XDG_DATA_DIRS /usr/local/share:/usr/share

if not set -q XDG_RUNTIME_DIR
    set -l runtime_dir "/run/user/"(id -u)
    if test -d "$runtime_dir"
        set -gx XDG_RUNTIME_DIR "$runtime_dir"
    end
end

# lua-language-server: keep the builtin meta cache out of the (read-only) install dir
set -q LLS_METAPATH; or set -gx LLS_METAPATH "$XDG_CACHE_HOME/lua-language-server/meta"

set --global --export STARSHIP_CONFIG "$HOME/.config/starship/fish.toml"

# Temporary override
# set -gx UV_NO_MODIFY_PATH 1
