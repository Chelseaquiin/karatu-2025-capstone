# Run after grading to reduce AWS cost.
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "==> Destroying Helm app releases"
Push-Location "$Root/helm"
helmfile destroy
Pop-Location

Write-Host "==> Destroying Terraform infrastructure"
Push-Location "$Root/terraform"
terraform destroy
Pop-Location
