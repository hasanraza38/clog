# clog shell hook
# Works for both Bash and Zsh

_CLOG_FILE=".clog"
_CLOG_MARKER=".clog_init"

_clog_write() {
  local cmd="$1"

  # Skip if clog not initialized in this directory
  [ ! -f "$_CLOG_MARKER" ] && return

  # Skip blank commands
  [ -z "$cmd" ] && return

  # Skip clog commands themselves
  [[ "$cmd" == clog* ]] && return

  # Skip noise commands
  [[ "$cmd" == "ls" || "$cmd" == "pwd" || "$cmd" == "clear" || "$cmd" == "exit" ]] && return

  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] $cmd" >> "$_CLOG_FILE"
}

# ── ZSH ──────────────────────────────────
if [ -n "$ZSH_VERSION" ]; then
  autoload -Uz add-zsh-hook
  _clog_zsh_preexec() {
    _clog_write "$1"
  }
  add-zsh-hook preexec _clog_zsh_preexec
fi

# ── BASH ─────────────────────────────────
if [ -n "$BASH_VERSION" ]; then
  _clog_bash_last_cmd=""
  _clog_bash_preexec() {
    local current_cmd
    current_cmd=$(history 1 | sed 's/^ *[0-9]* *//')
    if [ "$current_cmd" != "$_clog_bash_last_cmd" ]; then
      _clog_bash_last_cmd="$current_cmd"
      _clog_write "$current_cmd"
    fi
  }
  if [[ "$PROMPT_COMMAND" != *"_clog_bash_preexec"* ]]; then
    PROMPT_COMMAND="_clog_bash_preexec${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
  fi
fi