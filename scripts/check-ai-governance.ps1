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

if (-not (Test-Path "docs/resume-protocol.md")) {
  Fail "Missing docs/resume-protocol.md"
}

if (-not (Test-Path "docs/ROADMAP.md")) {
  Fail "Missing docs/ROADMAP.md"
}

if (-not (Test-Path "docs/DECISIONS.md")) {
  Fail "Missing docs/DECISIONS.md"
}

if (-not (Test-Path "docs/codex-review-standard.md")) {
  Fail "Missing docs/codex-review-standard.md"
}

if (-not (Test-Path "tasks/TASK_TEMPLATE.md")) {
  Fail "Missing tasks/TASK_TEMPLATE.md"
}

if (-not (Test-Path "scripts/session-snapshot.ps1")) {
  Fail "Missing scripts/session-snapshot.ps1"
}

if (-not (Test-Path "scripts/check-task-state.ps1")) {
  Fail "Missing scripts/check-task-state.ps1"
}

if (-not (Test-Path "scripts/check-pr-governance.ps1")) {
  Fail "Missing scripts/check-pr-governance.ps1"
}

if (-not (Test-Path "scripts/check-forbidden-paths.ps1")) {
  Fail "Missing scripts/check-forbidden-paths.ps1"
}

if (-not (Test-Path ".githooks/pre-commit")) {
  Fail "Missing .githooks/pre-commit"
}

$text = $PrTitle

if ($PrBodyPath -and (Test-Path $PrBodyPath)) {
  $text += "`n"
  $text += Get-Content -Raw -Encoding UTF8 $PrBodyPath
}

if ($text.Trim().Length -gt 0) {
  & "$PSScriptRoot/check-pr-governance.ps1" -PrTitle $PrTitle -PrBodyPath $PrBodyPath
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

Write-Host "AI governance checks passed."
