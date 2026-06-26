param(
  [Parameter(Mandatory = $true)]
  [string]$TaskId,
  [string]$BranchName = "",
  [switch]$CreateBranch
)

. "$PSScriptRoot/lib-governance.ps1"

$root = Get-RepoRoot
Set-Location $root

& "$PSScriptRoot/check-task-state.ps1" -TaskId $TaskId -Mode Start
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

if ([string]::IsNullOrWhiteSpace($BranchName)) {
  $BranchName = "feat/$TaskId"
}

$currentBranch = Get-CurrentBranch

if ($CreateBranch) {
  $existingBranches = Git-Output @("branch", "--list", $BranchName)
  if ([string]::IsNullOrWhiteSpace($existingBranches)) {
    & git checkout -b $BranchName
  } else {
    & git checkout $BranchName
  }
  if ($LASTEXITCODE -ne 0) {
    Fail "Failed to switch to branch $BranchName."
  }
  $currentBranch = $BranchName
} else {
  if ($currentBranch -eq "main") {
    Warn "Current branch is main. For normal development, rerun with -CreateBranch."
  }
}

$today = Get-Date -Format "yyyy-MM-dd"
$taskFile = Get-TaskFile $TaskId
$progressFile = Get-TaskProgressFile $TaskId

$content = Get-Content -Raw -Encoding UTF8 "PROJECT_STATUS.md"
$replacements = @{
  "status" = "IN_PROGRESS_$($TaskId.Replace('-', '_'))"
  "current_task" = $TaskId
  "current_task_file" = $taskFile
  "current_task_progress_file" = $progressFile
  "current_branch" = $currentBranch
  "current_step" = "准备执行 $TaskId"
  "next_action" = "输出实现计划，等待用户确认后再修改业务代码"
  "blocked" = "false"
  "updated_at" = $today
}

foreach ($key in $replacements.Keys) {
  $value = $replacements[$key]
  $replacement = "{0}: {1}" -f $key, $value
  $content = [regex]::Replace($content, "(?m)^$([regex]::Escape($key))\s*:.*$", $replacement)
}

Set-Content -Path "PROJECT_STATUS.md" -Value $content -Encoding UTF8

Write-Host "Task start gate passed."
Write-Host "task: $TaskId"
Write-Host "branch: $currentBranch"
Write-Host "PROJECT_STATUS.md updated."
