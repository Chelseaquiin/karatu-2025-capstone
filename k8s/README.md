# Kubernetes deployment notes

This project uses the official AWS Retail Store Sample App Helm charts instead of hand-written Deployment YAML files.

The Kubernetes objects are created by Helmfile from the upstream repository:

- catalog
- carts
- orders
- checkout
- ui
- services
- ingress/load balancer configuration

The only raw manifest kept here is `namespace.yaml`, because the assignment requires the application namespace to be `retail-app`.

Deploy the app using:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/deploy-app.ps1
```

That script clones the official app repository, copies the custom Helm values from `helm/custom-values/`, and runs `helmfile apply` against the EKS cluster currently configured in kubeconfig.
