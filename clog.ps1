# clog.ps1 — per-directory command logger
# Windows PowerShell version

$CLOG_VERSION = "1.0.0"
$CLOG_FILE = ".clog"
$CLOG_MARKER = ".clog_init"

function Is-Initialized {
  return Test-Path $CLOG_MARKER
}

function Cmd-Init {
  if (Is-Initialized) {
    Write-Host "⚠  clog already initialized here."
    exit 0
  }

  New-Item -ItemType File -Name $CLOG_MARKER | Out-Null
  New-Item -ItemType File -Name $CLOG_FILE | Out-Null

  $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $dir = Get-Location

  Add-Content $CLOG_FILE "# clog initialized on $ts"
  Add-Content $CLOG_FILE "# Directory: $dir"
  Add-Content $CLOG_FILE "# ──────────────────────────────────"
  Add-Content $CLOG_FILE ""

  Write-Host "✔  clog initialized in $dir"
  Write-Host "   Commands will be saved to .clog"
}

function Cmd-Show {
  if (-not (Is-Initialized)) {
    Write-Host "✘  Not initialized. Run: clog init"
    exit 1
  }
  Get-Content $CLOG_FILE
}

function Cmd-Last {
  param($n = 10)
  if (-not (Is-Initialized)) {
    Write-Host "✘  Not initialized. Run: clog init"
    exit 1
  }
  Get-Content $CLOG_FILE | Where-Object { $_ -match "^\[" } | Select-Object -Last $n
}

function Cmd-Search {
  param($term)
  if (-not (Is-Initialized)) {
    Write-Host "✘  Not initialized. Run: clog init"
    exit 1
  }
  if (-not $term) {
    Write-Host "Usage: clog search <term>"
    exit 1
  }
  $results = Get-Content $CLOG_FILE | Where-Object { $_ -match $term }
  if (-not $results) {
    Write-Host "  No results for `"$term`""
  } else {
    $results
  }
}

function Cmd-Status {
  if (Is-Initialized) {
    $count = (Get-Content $CLOG_FILE | Where-Object { $_ -match "^\[" }).Count
    $dir = Get-Location
    Write-Host "✔  clog active in $dir"
    Write-Host "   Commands logged: $count"
    Write-Host "   Log file: $dir\.clog"
  } else {
    Write-Host "✘  clog not initialized here."
    Write-Host "   Run: clog init"
  }
}

function Cmd-Clear {
  if (-not (Is-Initialized)) {
    Write-Host "✘  Not initialized. Run: clog init"
    exit 1
  }
  $confirm = Read-Host "⚠  Clear the log? [y/N]"
  if ($confirm -match "^[Yy]$") {
    Clear-Content $CLOG_FILE
    Write-Host "✔  Log cleared."
  } else {
    Write-Host "  Cancelled."
  }
}

function Cmd-Uninit {
  if (-not (Is-Initialized)) {
    Write-Host "✘  clog not initialized here."
    exit 1
  }
  $dir = Get-Location
  $confirm = Read-Host "⚠  Remove clog from $dir? Deletes .clog and .clog_init [y/N]"
  if ($confirm -match "^[Yy]$") {
    Remove-Item -Force $CLOG_FILE, $CLOG_MARKER
    Write-Host "✔  clog removed from $dir"
  } else {
    Write-Host "  Cancelled."
  }
}

function Cmd-Help {
  Write-Host ""
  Write-Host "  clog v$CLOG_VERSION — per-directory command logger"
  Write-Host ""
  Write-Host "  COMMANDS"
  Write-Host "    clog init            Start logging in this directory"
  Write-Host "    clog show            Print the full log"
  Write-Host "    clog last [n]        Show last n commands (default 10)"
  Write-Host "    clog search <term>   Search the log"
  Write-Host "    clog status          Check if clog is active here"
  Write-Host "    clog clear           Wipe the log"
  Write-Host "    clog uninit          Remove clog from this directory"
  Write-Host "    clog help            Show this help"
  Write-Host ""
}

# ── Router ───────────────────────────────
switch ($args[0]) {
  "init"    { Cmd-Init }
  "show"    { Cmd-Show }
  "last"    { Cmd-Last $args[1] }
  "search"  { Cmd-Search $args[1] }
  "status"  { Cmd-Status }
  "clear"   { Cmd-Clear }
  "uninit"  { Cmd-Uninit }
  "help"    { Cmd-Help }
  "--help"  { Cmd-Help }
  "-h"      { Cmd-Help }
  default   {
    if ($args[0]) {
      Write-Host "✘  Unknown command: $($args[0])"
      Write-Host "   Run: clog help"
    } else {
      Cmd-Help
    }
  }
}