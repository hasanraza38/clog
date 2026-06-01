# clog Windows uninstaller
# Run in PowerShell: .\uninstall.ps1

$CLOG_HOME = "$HOME\.clog_home"
$CLOG_BIN = "$HOME\bin"

Write-Host ""
Write-Host "  Uninstalling clog..."
Write-Host ""

# 1. Remove CLI files
if (Test-Path "$CLOG_BIN\clog.ps1") {
  Remove-Item -Force "$CLOG_BIN\clog.ps1"
  Write-Host "  ✔  Removed $CLOG_BIN\clog.ps1"
}
if (Test-Path "$CLOG_BIN\clog.cmd") {
  Remove-Item -Force "$CLOG_BIN\clog.cmd"
  Write-Host "  ✔  Removed $CLOG_BIN\clog.cmd"
}

# 2. Remove hook directory
if (Test-Path $CLOG_HOME) {
  Remove-Item -Recurse -Force $CLOG_HOME
  Write-Host "  ✔  Removed $CLOG_HOME"
}

# 3. Remove hook from PowerShell profile
if (Test-Path $PROFILE) {
  $profileContent = Get-Content $PROFILE
  $newContent = $profileContent | Where-Object { $_ -notmatch "clog hook" }
  Set-Content $PROFILE $newContent
  Write-Host "  ✔  Removed hook from $PROFILE"
}

# 4. Remove ~/bin from PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -like "*$CLOG_BIN*") {
  $newPath = ($currentPath.Split(";") | Where-Object { $_ -ne $CLOG_BIN }) -join ";"
  [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
  Write-Host "  ✔  Removed $CLOG_BIN from PATH"
}

Write-Host ""
Write-Host "   clog uninstalled successfully!"
Write-Host ""
Write-Host "  Restart PowerShell to apply changes."
Write-Host ""