param(
  [string]$TaskId = "",
  [string]$BaseRef = "",
  [switch]$Staged
)

. "$PSScriptRoot/lib-governance.ps1"

$root = Get-RepoRoot
Set-Location $root

if ([string]::IsNullOrWhiteSpace($TaskId)) {
  $TaskId = Get-CurrentTaskId
}

if ([string]::IsNullOrWhiteSpace($TaskId)) {
  Fail "TaskId is required and PROJECT_STATUS.md has no current_task."
}

$taskFile = Get-TaskFile $TaskId
Assert-RequiredFile $taskFile

$changed = Get-ChangedFiles -BaseRef $BaseRef -Staged:$Staged

if (-not $changed -or $changed.Count -eq 0) {
  Write-Host "No changed files to check."
  exit 0
}

$forbidden = @(Get-TaskSectionItems -TaskId $TaskId -Heading "Forbidden Paths")

$alwaysForbidden = @(
  ".env",
  ".env.",
  ".pem",
  ".key",
  ".p12",
  ".pfx",
  ".mp4",
  ".mov",
  ".avi",
  ".mkv",
  ".zip",
  ".rar",
  ".7z",
  ".exe"
)

$violations = @()

foreach ($file in $changed) {
  $normalized = $file.Replace("\", "/").Trim()

  foreach ($rule in $forbidden) {
    $ruleNorm = $rule.Replace("\", "/").Trim()
    if ($ruleNorm.Length -eq 0) { continue }

    if ($normalized -eq $ruleNorm -or $normalized.StartsWith($ruleNorm.TrimEnd("/") + "/")) {
      $violations += "$normalized matches task forbidden path '$ruleNorm'"
    }
  }

  foreach ($rule in $alwaysForbidden) {
    if ($normalized -eq $rule -or $normalized.Contains("/$rule") -or $normalized.EndsWith($rule)) {
      $violations += "$normalized matches always-forbidden pattern '$rule'"
    }
  }
}

if ($violations.Count -gt 0) {
  Write-Host "Forbidden path violations:"
  foreach ($v in $violations) {
    Write-Host "- $v"
  }
  exit 1
}

Write-Host "Forbidden path check passed."
Write-Host "checked_files: $($changed.Count)"
