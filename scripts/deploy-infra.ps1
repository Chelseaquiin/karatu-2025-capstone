# Run from project root: powershell -ExecutionPolicy Bypass -File scripts/deploy-infra.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "==> Checking AWS identity"
aws sts get-caller-identity

Write-Host "==> Bootstrap Terraform backend"
Push-Location "$Root/bootstrap-backend"
terraform init
terraform apply -auto-approve
Pop-Location

Write-Host "==> Deploy main infrastructure"
Push-Location "$Root/terraform"
terraform init
terraform plan
terraform apply -auto-approve
terraform output -json > "$Root/grading.json"
Pop-Location

Write-Host "==> Infrastructure deployed. grading.json generated."
