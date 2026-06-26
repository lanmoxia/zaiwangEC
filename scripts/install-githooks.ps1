. "$PSScriptRoot/lib-governance.ps1"

$root = Get-RepoRoot
Set-Location $root

Assert-RequiredFile ".githooks/pre-commit"
Assert-RequiredFile ".githooks/commit-msg"
Assert-RequiredFile ".githooks/pre-push"

git config core.hooksPath .githooks

Write-Host "Git hooks installed."
Write-Host "core.hooksPath: .githooks"
Write-Host ""
Write-Host "Note: direct push to main is blocked by pre-push unless ALLOW_MAIN_PUSH=1 is set."
