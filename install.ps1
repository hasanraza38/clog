# clog Windows installer
# Run in PowerShell: .\install.ps1

$CLOG_HOME = "$HOME\.clog_home"
$CLOG_BIN = "$HOME\bin"

Write-Host ""
Write-Host "  Installing clog..."
Write-Host ""

# 1. Create clog home directory
New-Item -ItemType Directory -Force -Path $CLOG_HOME | Out-Null
Write-Host "  ✔  Created $CLOG_HOME"

# 2. Copy hook file
Copy-Item -Force "clog_hook.ps1" "$CLOG_HOME\clog_hook.ps1"
Write-Host "  ✔  Hook installed → $CLOG_HOME\clog_hook.ps1"

# 3. Copy CLI script
New-Item -ItemType Directory -Force -Path $CLOG_BIN | Out-Null
Copy-Item -Force "clog.ps1" "$CLOG_BIN\clog.ps1"
Write-Host "  ✔  CLI installed  → $CLOG_BIN\clog.ps1"

# 4. Add ~/bin to PATH if not already there
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$CLOG_BIN*") {
  [Environment]::SetEnvironmentVariable("PATH", "$CLOG_BIN;$currentPath", "User")
  Write-Host "  ✔  Added $CLOG_BIN to PATH"
} else {
  Write-Host "  ✔  PATH already contains $CLOG_BIN (skipped)"
}

# 5. Create clog wrapper so user can type "clog" instead of "clog.ps1"
$wrapperPath = "$CLOG_BIN\clog.cmd"
$wrapperContent = "@echo off`r`npowershell -ExecutionPolicy Bypass -File `"$CLOG_BIN\clog.ps1`" %*"
Set-Content -Path $wrapperPath -Value $wrapperContent
Write-Host "  ✔  Wrapper created → $wrapperPath"

# 6. Add hook to PowerShell profile
$hookLine = ". `"$CLOG_HOME\clog_hook.ps1`"  #