# auto-ls.zsh - Automatic ls/git status on empty Enter
#
# This plugin automatically runs `ls` when changing directories
# and `git status` when in a git repository with uncommitted changes.
# Simply press Enter on an empty command line to trigger the behavior.

# Configuration variables (can be overridden before sourcing)
: ${AUTO_LS_COMMAND:=${aliases[ls]:-ls}}
: ${AUTO_LS_GIT_STATUS:=true}

# Internal state
_auto_ls_flag=false
_auto_ls_last_pwd=""

# Widget function bound to Enter key
auto-ls-enter() {
  if [[ -n $BUFFER ]]; then
    # If there's input, execute it normally
    zle accept-line
    return $status
  fi

  # Set flag and accept line to trigger precmd
  _auto_ls_flag=true
  zle accept-line
}

# precmd hook to execute ls/git status
_auto_ls_precmd() {
  if ! $_auto_ls_flag; then
    return
  fi
  _auto_ls_flag=false

  local is_new_dir=false
  if [[ $PWD != $_auto_ls_last_pwd ]]; then
    is_new_dir=true
    _auto_ls_last_pwd=$PWD
  fi

  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if $is_new_dir; then
      # Changed to a new directory - run ls
      ${=AUTO_LS_COMMAND}
    elif [[ $AUTO_LS_GIT_STATUS == true ]] && [[ -n $(git status --short 2>/dev/null) ]]; then
      # Same directory with uncommitted changes - run git status
      git status
    fi
  else
    if $is_new_dir; then
      # Outside git repository, changed to new directory - run ls
      ${=AUTO_LS_COMMAND}
    fi
  fi
}

# Register the widget and bind to Enter key
zle -N auto-ls-enter
bindkey '^m' auto-ls-enter

# Add precmd hook
if (( ${+precmd_functions} )); then
  precmd_functions+=(_auto_ls_precmd)
else
  precmd_functions=(_auto_ls_precmd)
fi
