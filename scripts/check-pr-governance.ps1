param(
  [string]$PrTitle = "",
  [string]$PrBodyPath = "",
  [string]$BaseRef = ""
)

. "$PSScriptRoot/lib-governance.ps1"

$root = Get-RepoRoot
Set-Location $root

$body = ""
if ($PrBodyPath -and (Test-Path $PrBodyPath)) {
  $body = Get-Content -Raw -Encoding UTF8 $PrBodyPath
}

$text = "$PrTitle`n$body"
$taskId = Get-TaskIdFromText $text

if ([string]::IsNullOrWhiteSpace($taskId)) {
  Fail "PR title/body must reference a task id such as TASK-0001."
}

if ($text -match "TASK-XXXX") {
  Fail "PR still contains placeholder TASK-XXXX."
}

$requiredMarkers = @(
  "governance:task",
  "governance:goal",
  "governance:summary",
  "governance:acceptance",
  "governance:verification",
  "governance:risk"
)

foreach ($marker in $requiredMarkers) {
  if ($body -and ($body -notmatch ([regex]::Escape($marker)))) {
    Fail "PR body is missing required governance marker: $marker"
  }
}

& "$PSScriptRoot/check-task-state.ps1" -TaskId $taskId -Mode PR -AllowDirty
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

if ($BaseRef) {
  & "$PSScriptRoot/check-forbidden-paths.ps1" -TaskId $taskId -BaseRef $BaseRef
} else {
  & "$PSScriptRoot/check-forbidden-paths.ps1" -TaskId $taskId
}

if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

Write-Host "PR governance check passed."
Write-Host "task: $taskId"
