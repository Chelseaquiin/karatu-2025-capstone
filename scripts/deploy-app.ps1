# Run from project root after terraform apply:
# powershell -ExecutionPolicy Bypass -File scripts/deploy-app.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$VendorDir = Join-Path $Root "vendor"
$AppRepo = Join-Path $VendorDir "retail-store-sample-app"

Write-Host "==> Reading Terraform outputs"
Push-Location "$Root/terraform"
$outputs = terraform output -json | ConvertFrom-Json
Pop-Location

$ClusterName = $outputs.cluster_name.value
$Region = $outputs.region.value
$VpcId = $outputs.vpc_id.value

$env:AWS_REGION = $Region
$env:MYSQL_HOST = ($outputs.mysql_endpoint.value -split ":")[0]
$env:MYSQL_DB = $outputs.mysql_database_name.value
$env:MYSQL_USER = $outputs.mysql_username.value
$env:MYSQL_PASSWORD = $outputs.mysql_password.value
$env:POSTGRES_HOST = ($outputs.postgres_endpoint.value -split ":")[0]
$env:POSTGRES_DB = $outputs.postgres_database_name.value
$env:POSTGRES_USER = $outputs.postgres_username.value
$env:POSTGRES_PASSWORD = $outputs.postgres_password.value
$env:DYNAMODB_TABLE = $outputs.dynamodb_table_name.value

Write-Host "==> Updating kubeconfig for EKS cluster $ClusterName"
aws eks update-kubeconfig --region $Region --name $ClusterName
kubectl config current-context

Write-Host "==> Creating retail-app namespace"
kubectl create namespace retail-app --dry-run=client -o yaml | kubectl apply -f -

Write-Host "==> Cloning/updating official AWS retail sample app repo"
New-Item -ItemType Directory -Force -Path $VendorDir | Out-Null
if (!(Test-Path $AppRepo)) {
  git clone https://github.com/aws-containers/retail-store-sample-app.git $AppRepo
} else {
  Push-Location $AppRepo
  git pull
  Pop-Location
}

Write-Host "==> Installing/upgrading AWS Load Balancer Controller"
helm repo add eks https://aws.github.io/eks-charts | Out-Null
helm repo update | Out-Null
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller `
  -n kube-system `
  --set clusterName=$ClusterName `
  --set region=$Region `
  --set vpcId=$VpcId `
  --set serviceAccount.create=true `
  --set serviceAccount.name=aws-load-balancer-controller

Write-Host "==> Deploying retail-store-sample-app with Helmfile into EKS"
Push-Location "$Root/helm"
helmfile apply
Pop-Location

Write-Host "==> Checking app status"
kubectl get pods -n retail-app
kubectl get svc -n retail-app
kubectl get ingress -n retail-app
Write-Host "If ingress ADDRESS is blank, wait 2-5 minutes and rerun: kubectl get ingress -n retail-app"
