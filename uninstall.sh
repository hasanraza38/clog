#!/usr/bin/env bash

CLOG_HOME="$HOME/.clog_home"

# ── Detect OS ────────────────────────────
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  OS="windows"
fi

echo ""
echo "  Uninstalling clog..."
echo ""

# 1. Remove CLI binary
if [ -f "/usr/local/bin/clog" ]; then
  rm -f "/usr/local/bin/clog"
  echo "  ✔  Removed /usr/local/bin/clog"
elif [ -f "$HOME/bin/clog" ]; then
  rm -f "$HOME/bin/clog"
  echo "  ✔  Removed ~/bin/clog"
fi

# 2. Remove hook directory
if [ -d "$CLOG_HOME" ]; then
  rm -rf "$CLOG_HOME"
  echo "  ✔  Removed ~/.clog_home"
fi

# 3. Remove hook line from shell configs
_remove_from_shell() {
  local rc_file="$1"
  if [ -f "$rc_file" ] && grep -q "clog hook" "$rc_file"; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' '/clog hook/d' "$rc_file"   # Mac
    else
      sed -i '/clog hook/d' "$rc_file"      # Linux
    fi
    echo "  ✔  Removed hook from $rc_file"
  fi
}

if [ "$OS" == "linux" ]; then
  _remove_from_shell "$HOME/.zshrc"
  _remove_from_shell "$HOME/.bashrc"
elif [ "$OS" == "mac" ]; then
  _remove_from_shell "$HOME/.zshrc"
  _remove_from_shell "$HOME/.bash_profile"
  _remove_from_shell "$HOME/.bashrc"
elif [ "$OS" == "windows" ]; then
  _remove_from_shell "$HOME/.bashrc"
  _remove_from_shell "$HOME/.bash_profile"
fi

echo ""
echo "  ✅  clog uninstalled successfully!"
echo ""
echo "  Reload your shell:"
echo "    source ~/.zshrc    (zsh)"
echo "    source ~/.bashrc   (bash)"
echo ""