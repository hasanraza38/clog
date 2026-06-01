#!/usr/bin/env bash

CLOG_HOME="$HOME/.clog_home"
GITHUB_RAW="https://raw.githubusercontent.com/hasanraza38/clog/master"
HOOK_LINE="source \"$HOME/.clog_home/clog_hook.sh\"  # clog hook"

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
echo "  Installing clog..."
echo "  Detected OS: $OS"
echo ""

# 1. Create clog home directory
mkdir -p "$CLOG_HOME"
mkdir -p "$HOME/bin"

# 2. Download hook file
curl -sSL "$GITHUB_RAW/clog_hook.sh" -o "$CLOG_HOME/clog_hook.sh"
echo "  ✔  Hook installed → $CLOG_HOME/clog_hook.sh"

# 3. Download CLI binary
curl -sSL "$GITHUB_RAW/bin/clog" -o "$HOME/bin/clog"
chmod +x "$HOME/bin/clog"
echo "  ✔  CLI installed  → $HOME/bin/clog"

# 4. Add ~/bin to PATH if needed
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  echo "" >> "$HOME/.zshrc"
  echo "export PATH=\"\$HOME/bin:\$PATH\"  # clog path" >> "$HOME/.zshrc"
  echo "" >> "$HOME/.bashrc"
  echo "export PATH=\"\$HOME/bin:\$PATH\"  # clog path" >> "$HOME/.bashrc"
  echo "  ✔  Added ~/bin to PATH"
fi

# 5. Add hook to shell configs
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

if [ "$OS" == "linux" ]; then
  _add_to_shell "$HOME/.zshrc"
  _add_to_shell "$HOME/.bashrc"
elif [ "$OS" == "mac" ]; then
  _add_to_shell "$HOME/.zshrc"
  _add_to_shell "$HOME/.bash_profile"
  _add_to_shell "$HOME/.bashrc"
elif [ "$OS" == "windows" ]; then
  _add_to_shell "$HOME/.bashrc"
  _add_to_shell "$HOME/.bash_profile"
fi

# 6. Add to global gitignore
GLOBAL_GITIGNORE="$HOME/.gitignore_global"
touch "$GLOBAL_GITIGNORE"
if ! grep -q "^\.clog$" "$GLOBAL_GITIGNORE"; then
  echo ".clog" >> "$GLOBAL_GITIGNORE"
  echo ".clog_init" >> "$GLOBAL_GITIGNORE"
  echo "  ✔  Added .clog to global gitignore"
fi
git config --global core.excludesfile "$GLOBAL_GITIGNORE" 2>/dev/null || true

echo ""
echo "   clog installed successfully!"
echo ""
if [ "$OS" == "mac" ]; then
  echo "  NEXT — reload your shell:"
  echo "    source ~/.zshrc"
elif [ "$OS" == "windows" ]; then
  echo "  NEXT — restart Git Bash or run:"
  echo "    source ~/.bashrc"
else
  echo "  NEXT — reload your shell:"
  echo "    source ~/.zshrc    (zsh)"
  echo "    source ~/.bashrc   (bash)"
fi
echo ""
echo "  THEN:"
echo "    cd your-project"
echo "    clog init"
echo ""