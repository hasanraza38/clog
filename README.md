# clog

A lightweight per-directory command logger for your terminal.
Every command you run gets saved to a `.clog` file in your project, open it in any text editor.

---

## Why clog?

Ever opened an old project and thought *"what commands did I run to set this up?"*
clog silently logs everything so you never lose track.

---

## Install

### Linux / Mac
```bash
curl -sSL https://raw.githubusercontent.com/hasanraza38/clog/main/install.sh | bash
source ~/.zshrc   # or source ~/.bashrc
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/hasanraza38/clog/main/install.ps1 | iex
```

---

## Usage

```bash
cd your-project/

clog init            # start logging in this directory
clog show            # print the full log
clog last 10         # show last 10 commands
clog search npm      # search the log
clog status          # is clog active here?
clog clear           # wipe the log
clog uninit          # remove clog from this directory
clog help            # all commands
```

---

## How it works

After `clog init`, a plain `.clog` file is created in your directory:


clog initialized on 2026-06-02 14:00:00
Directory: /home/user/myproject
────────────────────────────────────────
[2026-06-02 14:01:22] npm install
[2026-06-02 14:01:45] npm run dev
[2026-06-02 14:03:10] git add .
[2026-06-02 14:03:15] git commit -m "init"


Open `.clog` in **VS Code, Vim, Nano, Notepad++** — any text editor works.

---

## OS Support

| OS | Status |
|---|---|
| Linux | ✅ Supported |
| Mac | ✅ Supported |
| Windows (PowerShell) | ✅ Supported |
| Windows (Git Bash) | ✅ Supported |

## Shell Support

| Shell | Status |
|---|---|
| Zsh | ✅ Supported |
| Bash | ✅ Supported |
| PowerShell | ✅ Supported |

---

## Files created per project

| File | Purpose |
|---|---|
| `.clog` | Plain text log — open in any editor |
| `.clog_init` | Marker file — tells clog this directory is active |

> Both files are automatically added to your global `.gitignore` so they never get committed.

---

## Uninstall

### Linux / Mac
```bash
curl -sSL https://raw.githubusercontent.com/hasanraza38/clog/main/uninstall.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/hasanraza38/clog/main/uninstall.ps1 | iex
```

---

## License

MIT — free to use, modify and share.