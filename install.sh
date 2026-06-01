#!/usr/bin/env bash

CLOG_HOME="$HOME/.clog"
BIN_TARGET="/usr/local/bin/clog"
HOOK_LINE="source \"$HOME/.clog/clog_hook.sh\"  # clog hook"

echo ""
echo "  Installing clog..."
echo ""

# 1. Create clog home directory
mkdir -p "$CLOG_HOME"

# 2. Copy hook file
cp clog_hook.sh "$CLOG_HOME/clog_hook.sh"
echo "  ✔  Hook installed → $CLOG_HOME/clog_hook.sh"

# 3. Install CLI binary
if cp bin/clog "$BIN_TARGET" 2>/dev/null; then
  chmod +x "$BIN_TARGET"
  echo "  ✔  CLI installed  → $BIN_TARGET"
else
  mkdir -p "$HOME/bin"
  cp bin/clog "$HOME/bin/clog"
  chmod +x "$HOME/bin/clog"
  echo "  ✔  CLI installed  → $HOME/bin/clog"
  echo "     (no sudo — installed to ~/bin)"
fi

# 4. Add hook to shell configs
_add_to_shell() {
  local rc_file="$1"
  if [ -f "$rc_file" ]; then
    if grep -q "clog hook" "$rc_file"; then
      echo "  ✔  Hook already in $rc_file (skipped)"
    else
      echo "" >> "$rc_file"
      echo "$HOOK_LINE" >> "$rc_file"
      echo "  ✔  Hook added to $rc_file"
    fi
  fi
}

_add_to_shell "$HOME/.zshrc"
_add_to_shell "$HOME/.bashrc"

# 5. Add to global gitignore
GLOBAL_GITIGNORE="$HOME/.gitignore_global"
touch "$GLOBAL_GITIGNORE"
if ! grep -q "^\.clog$" "$GLOBAL_GITIGNORE"; then
  echo ".clog" >> "$GLOBAL_GITIGNORE"
  echo ".clog_init" >> "$GLOBAL_GITIGNORE"
  echo "  ✔  Added .clog to global gitignore"
fi
git config --global core.excludesfile "$GLOBAL_GITIGNORE" 2>/dev/null || true

echo ""g
echo "   clog installed!"
echo ""
echo "  NEXT — reload your shell:"
echo "    source ~/.zshrc    (zsh)"
echo "    source ~/.bashrc   (bash)"
echo ""
echo "  THEN:"
echo "    cd your-project"
echo "    clog init"
echo ""

