$ErrorActionPreference = "Stop"

function Run-Git($Arguments) {
  try {
    $output = & git @Arguments 2>&1
    return ($output | Out-String).Trim()
  } catch {
    return "ERROR: $($_.Exception.Message)"
  }
}

function Read-ProjectStatusValue($Key) {
  if (-not (Test-Path "PROJECT_STATUS.md")) {
    return ""
  }

  $line = Select-String -Path "PROJECT_STATUS.md" -Pattern "^\s*$Key\s*:" | Select-Object -First 1
  if (-not $line) {
    return ""
  }

  return ($line.Line -replace "^\s*$Key\s*:\s*", "").Trim()
}

$currentTask = Read-ProjectStatusValue "current_task"
$currentTaskFile = Read-ProjectStatusValue "current_task_file"
$status = Read-ProjectStatusValue "status"
$projectBranch = Read-ProjectStatusValue "current_branch"
$lastGoodCommit = Read-ProjectStatusValue "last_good_commit"
$blocked = Read-ProjectStatusValue "blocked"

$branch = Run-Git @("branch", "--show-current")
$shortStatus = Run-Git @("status", "--short")
$branchStatus = Run-Git @("status", "-sb")
$lastCommit = Run-Git @("log", "-1", "--oneline")
$recentCommits = Run-Git @("log", "--oneline", "-3")
$remote = Run-Git @("remote", "-v")

if ([string]::IsNullOrWhiteSpace($shortStatus)) {
  $workingTree = "clean"
} else {
  $workingTree = "dirty"
}

Write-Host "# Session Snapshot"
Write-Host ""
Write-Host "time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
Write-Host "project_status: $status"
Write-Host "current_task: $currentTask"
Write-Host "current_task_file: $currentTaskFile"
Write-Host "project_status_branch: $projectBranch"
Write-Host "actual_branch: $branch"
Write-Host "last_good_commit: $lastGoodCommit"
Write-Host "actual_last_commit: $lastCommit"
Write-Host "working_tree: $workingTree"
Write-Host "blocked: $blocked"
Write-Host ""

Write-Host "## git status -sb"
Write-Host $branchStatus
Write-Host ""

Write-Host "## git status --short"
if ([string]::IsNullOrWhiteSpace($shortStatus)) {
  Write-Host "(clean)"
} else {
  Write-Host $shortStatus
}
Write-Host ""

Write-Host "## recent commits"
Write-Host $recentCommits
Write-Host ""

Write-Host "## remotes"
Write-Host $remote
Write-Host ""

if ($currentTaskFile -and (Test-Path $currentTaskFile)) {
  Write-Host "## current task header"
  Get-Content -Path $currentTaskFile -Encoding UTF8 -TotalCount 12
} else {
  Write-Host "## current task header"
  Write-Host "Current task file not found: $currentTaskFile"
}

Write-Host ""
Write-Host "## recommended next step"

if ($workingTree -eq "dirty") {
  Write-Host "Stop and inspect uncommitted changes before continuing."
} elseif ($blocked -eq "true") {
  Write-Host "Project is blocked. Ask for human confirmation before continuing."
} else {
  Write-Host "Workspace is clean. Read the task progress file and continue only after user confirmation."
}
