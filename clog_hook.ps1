# clog PowerShell hook
# Add this to your PowerShell profile ($PROFILE)

$_CLOG_FILE = ".clog"
$_CLOG_MARKER = ".clog_init"

function _clog_write {
  param($cmd)

  # Skip if clog not initialized in this directory
  if (-not (Test-Path $_CLOG_MARKER)) { return }

  # Skip blank commands
  if (-not $cmd) { return }

  # Skip clog commands themselves
  if ($cmd -match "^clog") { return }

  # Skip noise commands
  if ($cmd -match "^(ls|pwd|clear|exit|cls)$") { return }

  $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content $_CLOG_FILE "[$ts] $cmd"
}

# Hook into PowerShell command history
function prompt {
  $lastCmd = (Get-History -Count 1).CommandLine
  if ($lastCmd) {
    _clog_write $lastCmd
  }

  # Keep default prompt look
  "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}