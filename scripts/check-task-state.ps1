param(
  [string]$TaskId = "",
  [ValidateSet("Start", "Commit", "Push", "PR", "Review", "Any")]
  [string]$Mode = "Any",
  [switch]$AllowDirty
)

. "$PSScriptRoot/lib-governance.ps1"

$root = Get-RepoRoot
Set-Location $root

Assert-RequiredFile "CLAUDE.md"
Assert-RequiredFile "AGENTS.md"
Assert-RequiredFile "PROJECT_STATUS.md"
Assert-RequiredFile "docs/ai-workflow.md"
Assert-RequiredFile "docs/resume-protocol.md"
Assert-RequiredFile "docs/ROADMAP.md"
Assert-RequiredFile "docs/DECISIONS.md"
Assert-RequiredFile "tasks/TASK_TEMPLATE.md"

if ([string]::IsNullOrWhiteSpace($TaskId)) {
  $TaskId = Get-CurrentTaskId
}

if ([string]::IsNullOrWhiteSpace($TaskId)) {
  Fail "TaskId is required and PROJECT_STATUS.md has no current_task."
}

if ($TaskId -notmatch "^TASK-\d{4}$") {
  Fail "Invalid TaskId: $TaskId"
}

$taskFile = Get-TaskFile $TaskId
$progressFile = Get-TaskProgressFile $TaskId
Assert-RequiredFile $taskFile
Assert-RequiredFile $progressFile

$taskStatus = Get-TaskStatus $TaskId
$projectTask = Get-ProjectStatusValue "current_task"
$projectTaskFile = Get-ProjectStatusValue "current_task_file"
$projectProgressFile = Get-ProjectStatusValue "current_task_progress_file"
$blocked = Get-ProjectStatusValue "blocked"
$branch = Get-CurrentBranch
$status = Get-WorkingTreeStatus

if ($blocked -eq "true") {
  Fail "PROJECT_STATUS.md says blocked: true."
}

if ($projectTask -and $projectTask -ne $TaskId) {
  Warn "PROJECT_STATUS current_task is $projectTask, but checking $TaskId."
}

if ($projectTaskFile -and $projectTaskFile -ne $taskFile) {
  Warn "PROJECT_STATUS current_task_file is $projectTaskFile, expected $taskFile."
}

if ($projectProgressFile -and $projectProgressFile -ne $progressFile) {
  Warn "PROJECT_STATUS current_task_progress_file is $projectProgressFile, expected $progressFile."
}

$allowed = @()
switch ($Mode) {
  "Start"  { $allowed = @("Approved", "In Progress") }
  "Commit" { $allowed = @("Approved", "In Progress", "Review", "Changes Requested") }
  "Push"   { $allowed = @("Approved", "In Progress", "Review", "Changes Requested") }
  "PR"     { $allowed = @("Approved", "In Progress", "Review", "Changes Requested") }
  "Review" { $allowed = @("Review", "Changes Requested", "Done", "Approved", "In Progress") }
  default  { $allowed = @("Approved", "In Progress", "Review", "Changes Requested", "Done") }
}

if ($allowed -notcontains $taskStatus) {
  Fail "Task $TaskId status '$taskStatus' is not allowed for mode '$Mode'. Allowed: $($allowed -join ', ')"
}

if (-not $AllowDirty -and -not [string]::IsNullOrWhiteSpace($status)) {
  Fail "Working tree is dirty. Run session-snapshot.ps1 and inspect changes before continuing."
}

Write-Host "Task state check passed."
Write-Host "task: $TaskId"
Write-Host "task_status: $taskStatus"
Write-Host "mode: $Mode"
Write-Host "branch: $branch"
