param(
  [Parameter(Mandatory = $true)]
  [string]$CommitMsgPath
)

. "$PSScriptRoot/lib-governance.ps1"

$root = Get-RepoRoot
Set-Location $root

if (-not (Test-Path $CommitMsgPath)) {
  Fail "Commit message file not found: $CommitMsgPath"
}

$message = Get-Content -Raw -Encoding UTF8 $CommitMsgPath
$taskId = Get-TaskIdFromText $message

if ([string]::IsNullOrWhiteSpace($taskId)) {
  Fail "Commit message must contain a task id such as TASK-0001."
}

& "$PSScriptRoot/check-task-state.ps1" -TaskId $taskId -Mode Commit -AllowDirty
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& "$PSScriptRoot/check-forbidden-paths.ps1" -TaskId $taskId -Staged
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

Write-Host "Commit message check passed: $taskId"
