# Auto-start Zellij when opening Ghostty.
# Set GHOSTTY_AUTO_ZELLIJ=0 to disable.
export GHOSTTY_AUTO_ZELLIJ="${GHOSTTY_AUTO_ZELLIJ:-1}"

_ghostty_auto_zellij() {
    [[ $- == *i* ]] || return
    [[ "${GHOSTTY_AUTO_ZELLIJ:-0}" == "1" ]] || return
    [[ "${ZS_SUPPRESS_AUTO_ZELLIJ:-0}" == "1" ]] && return
    [[ "${TERM_PROGRAM:-}" == "ghostty" ]] || return
    [[ -z "${ZELLIJ:-}" ]] || return
    command -v zellij >/dev/null 2>&1 || return

    local session_name="${ZELLIJ_SESSION_NAME:-}"
    if [[ -z "$session_name" ]]; then
        local names=(alpha beta gamma delta epsilon zeta eta theta iota kappa)
        local existing
        existing="$(zellij list-sessions --no-formatting 2>/dev/null)"
        for candidate in "${names[@]}"; do
            if ! grep -qE "^${candidate}( |$|\\[)" <<< "$existing"; then
                session_name="$candidate"
                break
            fi
        done
        if [[ -z "$session_name" ]]; then
            local n=2
            while [[ -z "$session_name" ]]; do
                for candidate in "${names[@]}"; do
                    if ! grep -qE "^${candidate}-${n}( |$|\\[)" <<< "$existing"; then
                        session_name="${candidate}-${n}"
                        break 2
                    fi
                done
                ((n++))
            done
        fi
    fi

    zellij attach --create "$session_name"
}

_ghostty_auto_zellij
unset -f _ghostty_auto_zellij
