#!/bin/bash
# Refresh app icons for every workspace in the bar.
#
# Called from aerospace's exec-on-workspace-change on every switch, so it must
# never block or pile up: every aerospace call has a timeout, only one instance
# runs at a time, and bursts of switches collapse into a single follow-up run.

CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

LOCK_DIR="${TMPDIR:-/tmp}/sketchybar_workspace_icons.lock"
PENDING="$LOCK_DIR.pending"

# aerospace with a hard timeout (macOS has no coreutils `timeout`)
aero() { perl -e 'alarm shift; exec @ARGV' 3 aerospace "$@"; }

acquire_lock() {
    mkdir "$LOCK_DIR" 2>/dev/null && { echo $$ > "$LOCK_DIR/pid"; return 0; }
    # Take over a lock left behind by a dead process
    local holder
    holder=$(cat "$LOCK_DIR/pid" 2>/dev/null)
    if [ -n "$holder" ] && ! kill -0 "$holder" 2>/dev/null; then
        rm -rf "$LOCK_DIR"
        mkdir "$LOCK_DIR" 2>/dev/null && { echo $$ > "$LOCK_DIR/pid"; return 0; }
    fi
    return 1
}

update_all() {
    local workspaces windows sid apps icon_strip
    workspaces=$(aero list-workspaces --all) || return
    windows=$(aero list-windows --all --format '%{workspace}|%{app-name}') || return

    for sid in $workspaces; do
        apps=$(awk -F'|' -v ws="$sid" '$1 == ws { print $2 }' <<<"$windows")
        icon_strip=""
        if [ -n "$apps" ]; then
            icon_strip=" "
            while read -r app; do
                icon_strip+=" $("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app")"
            done <<<"$apps"
        fi
        sketchybar --set "space.$sid" drawing=on label="$icon_strip"
    done
}

if ! acquire_lock; then
    # Another run is in progress; ask it to go again when it finishes
    touch "$PENDING"
    exit 0
fi
trap 'rm -rf "$LOCK_DIR"' EXIT

while :; do
    rm -f "$PENDING"
    update_all
    [ -e "$PENDING" ] || break
done
