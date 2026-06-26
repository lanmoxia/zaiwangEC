$ErrorActionPreference = "Stop"

function Fail($Message) {
  Write-Error $Message
  exit 1
}

function Warn($Message) {
  Write-Warning $Message
}

function Get-RepoRoot {
  $root = (& git rev-parse --show-toplevel 2>$null | Out-String).Trim()
  if ([string]::IsNullOrWhiteSpace($root)) {
    Fail "Not inside a Git repository."
  }
  return $root
}

function Git-Output([string[]]$Arguments) {
  $output = & git @Arguments 2>&1
  $text = ($output | Out-String).Trim()
  return $text
}

function Get-ProjectStatusValue($Key) {
  if (-not (Test-Path "PROJECT_STATUS.md")) {
    return ""
  }

  $line = Get-Content -Path "PROJECT_STATUS.md" -Encoding UTF8 | Select-String -Pattern "^\s*$Key\s*:" | Select-Object -First 1
  if (-not $line) {
    return ""
  }

  return ($line.Line -replace "^\s*$Key\s*:\s*", "").Trim()
}

function Get-TaskIdFromText($Text) {
  if ($Text -match "(TASK-\d{4})") {
    return $Matches[1]
  }
  return ""
}

function Get-CurrentTaskId {
  return Get-ProjectStatusValue "current_task"
}

function Get-TaskFile($TaskId) {
  return "tasks/$TaskId.md"
}

function Get-TaskProgressFile($TaskId) {
  return "tasks/$TaskId.progress.md"
}

function Get-TaskStatus($TaskId) {
  $taskFile = Get-TaskFile $TaskId
  if (-not (Test-Path $taskFile)) {
    Fail "Task file not found: $taskFile"
  }

  $lines = Get-Content -Path $taskFile -Encoding UTF8

  foreach ($line in $lines) {
    if ($line -match "^\s*>\s*Status\s*:\s*([^\s]+)") {
      return $Matches[1].Trim()
    }
  }

  $statusLabel = ([string][char]29366) + ([string][char]24577)
  $cnColon = [string][char]65306
  $pattern = [regex]::Escape($statusLabel) + "[" + [regex]::Escape($cnColon) + ":]\s*([^\s]+)"

  foreach ($line in $lines) {
    if ($line -match $pattern) {
      return $Matches[1].Trim()
    }
  }

  Fail "Task status not found in $taskFile. Add a machine-readable line like '> Status: Approved'."
}

function Assert-RequiredFile($Path) {
  if (-not (Test-Path $Path)) {
    Fail "Missing required file: $Path"
  }
}

function Get-WorkingTreeStatus {
  return Git-Output @("status", "--short")
}

function Get-CurrentBranch {
  return Git-Output @("branch", "--show-current")
}

function Get-ChangedFiles {
  param(
    [string]$BaseRef = "",
    [switch]$Staged,
    [switch]$Working
  )

  if ($Staged) {
    $text = Git-Output @("diff", "--cached", "--name-only")
  } elseif ($BaseRef) {
    $text = Git-Output @("diff", "--name-only", "$BaseRef...HEAD")
  } elseif ($Working) {
    $text = Git-Output @("diff", "--name-only")
    $stagedText = Git-Output @("diff", "--cached", "--name-only")
    if ($stagedText) {
      $text = "$text`n$stagedText"
    }
  } else {
    $text = Git-Output @("status", "--short")
    $lines = @()
    foreach ($line in ($text -split "`n")) {
      if ($line.Trim().Length -eq 0) { continue }
      $path = $line.Substring(3).Trim()
      if ($path -match " -> ") {
        $path = ($path -split " -> ")[-1].Trim()
      }
      $lines += $path
    }
    return $lines | Sort-Object -Unique
  }

  if ([string]::IsNullOrWhiteSpace($text)) {
    return @()
  }

  return ($text -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }) | Sort-Object -Unique
}

function Get-TaskSectionItems {
  param(
    [string]$TaskId,
    [string]$Heading
  )

  $taskFile = Get-TaskFile $TaskId
  if (-not (Test-Path $taskFile)) {
    Fail "Task file not found: $taskFile"
  }

  $items = @()
  $inside = $false

  foreach ($line in Get-Content -Path $taskFile -Encoding UTF8) {
    if ($line -match "^###\s+$([regex]::Escape($Heading))\s*$") {
      $inside = $true
      continue
    }

    if ($inside -and $line -match "^(##|###)\s+") {
      break
    }

    if ($inside -and $line -match "^\s*-\s+(.+?)\s*$") {
      $item = $Matches[1].Trim()
      $item = $item.Trim([char]0x60).Trim()
      if ($item.Length -gt 0) {
        $items += $item
      }
    }
  }

  return $items
}
