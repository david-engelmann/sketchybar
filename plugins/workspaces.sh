#!/bin/bash
# Draws the AeroSpace workspace pills: which display each sits on, whether it is
# shown (only workspaces that have windows or are on screen), its app icons, and
# its highlight. One script, one sketchybar call per refresh.
#
# Runs on: workspace switch (aerospace exec-on-workspace-change), windows
# opening/closing, displays plugged/unplugged, wake (sketchybar events).
# Every aerospace call has a timeout and only one instance runs at a time, so a
# slow AeroSpace can never pile up processes.

CONFIG_DIR="${CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/sketchybar}"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map_fn.sh" >/dev/null # defines icon_map()

# Monitors were plugged or unplugged: give AeroSpace a moment to move its
# workspaces, then re-arrange everything (arrange.sh redraws the bar when done)
if [ "$SENDER" = display_change ]; then
    sleep 2
    exec "$HOME/.config/aerospace/arrange.sh"
fi

LOCK_DIR="${TMPDIR:-/tmp}/sketchybar_workspaces.lock"
PENDING="$LOCK_DIR.pending"

# aerospace with a hard timeout (macOS has no coreutils `timeout`)
aero() { perl -e 'alarm shift; exec @ARGV' 3 aerospace "$@"; }

# style <workspace> focused|visible|hidden — appends to the global args array
style() {
    case "$2" in
        focused) args+=(--set "space.$1" background.color="$ACTIVE_BG" background.border_width=2 icon.color="$BASE" label.color="$BASE") ;;
        visible) args+=(--set "space.$1" background.color="$ITEM_BG" background.border_width=1 icon.color="$TEXT" label.color="$TEXT") ;;
        *)       args+=(--set "space.$1" background.color="$ITEM_BG" background.border_width=0 icon.color="$TEXT" label.color="$TEXT") ;;
    esac
}

# On a workspace switch, move the highlight immediately — no aerospace round-trip
if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    args=()
    [ -n "$AEROSPACE_PREV_WORKSPACE" ] && style "$AEROSPACE_PREV_WORKSPACE" hidden
    style "$AEROSPACE_FOCUSED_WORKSPACE" focused
    args+=(--set "space.$AEROSPACE_FOCUSED_WORKSPACE" drawing=on)
    sketchybar "${args[@]}"
fi

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
    local workspaces windows sid visible focused monitor apps app icons show m d
    local -a display
    workspaces=$(aero list-workspaces --all --format '%{workspace}|%{workspace-is-visible}|%{workspace-is-focused}|%{monitor-id}') || return
    windows=$(aero list-windows --all --format '%{workspace}|%{app-name}') || return

    # AeroSpace numbers monitors left to right; sketchybar numbers displays its
    # own way (and macOS reshuffles it when monitors are replugged). Match the
    # two by physical position, so pills always land on the right screen.
    while read -r m d; do
        [ -n "$m" ] && display[$m]=$d
    done <<<"$(sketchybar --query displays | jq -r 'sort_by(.frame.x, .frame.y) | to_entries[] | "\(.key + 1) \(.value["arrangement-id"])"')"

    args=()
    while IFS='|' read -r sid visible focused monitor; do
        [ -n "$sid" ] || continue
        # One icon per app, however many windows it has
        apps=$(awk -F'|' -v ws="$sid" '$1 == ws && !seen[$2]++ { print $2 }' <<<"$windows")
        icons=""
        while read -r app; do
            [ -n "$app" ] || continue
            icon_map "$app"
            icons+=" $icon_result"
        done <<<"$apps"

        show=off
        { [ -n "$apps" ] || [ "$visible" = true ]; } && show=on
        args+=(--set "space.$sid" display="${display[$monitor]:-active}" drawing="$show" label="$icons")
        if [ "$focused" = true ]; then style "$sid" focused
        elif [ "$visible" = true ]; then style "$sid" visible
        else style "$sid" hidden
        fi
    done <<<"$workspaces"

    # AeroSpace running but seeing no windows at all: either its Accessibility
    # permission is stale, or macOS's Accessibility layer is broken for this
    # login session (seen after a WindowServer crash; fixed by a reboot).
    # Say so in the bar instead of failing silently.
    if [ -z "$windows" ] && [ "$(aero list-apps --count 2>/dev/null || echo 0)" -ge 3 ]; then
        args+=(--set aerospace_health drawing=on)
    else
        args+=(--set aerospace_health drawing=off)
    fi

    sketchybar "${args[@]}"
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
