param(
  [string]$PrBodyPath = "",
  [string]$PrTitle = ""
)

$ErrorActionPreference = "Stop"

function Fail($Message) {
  Write-Error $Message
  exit 1
}

if (-not (Test-Path "CLAUDE.md")) {
  Fail "Missing CLAUDE.md"
}

if (-not (Test-Path "AGENTS.md")) {
  Fail "Missing AGENTS.md"
}

if (-not (Test-Path "PROJECT_STATUS.md")) {
  Fail "Missing PROJECT_STATUS.md"
}

if (-not (Test-Path "docs/ai-workflow.md")) {
  Fail "Missing docs/ai-workflow.md"
}

if (-not (Test-Path "docs/codex-review-standard.md")) {
  Fail "Missing docs/codex-review-standard.md"
}

if (-not (Test-Path "tasks/TASK_TEMPLATE.md")) {
  Fail "Missing tasks/TASK_TEMPLATE.md"
}

$text = $PrTitle

if ($PrBodyPath -and (Test-Path $PrBodyPath)) {
  $text += "`n"
  $text += Get-Content -Raw -Encoding UTF8 $PrBodyPath
}

if ($text.Trim().Length -gt 0) {
  if ($text -notmatch "TASK-\d{4}") {
    Fail "PR title/body must reference a task id such as TASK-0001."
  }
}

Write-Host "AI governance checks passed."
