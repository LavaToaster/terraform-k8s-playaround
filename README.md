# Personal Infra

## Setup

### Provision Cloud

```
terraform init
terraform apply
```

Some amount of time later

### Provision Kubernetes

**Configure Kubefile**
 
```
doctl k cluster kubeconfig save <clustername>
```

**Setup CRD's**
 
```
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.10/deploy/manifests/00-crds.yaml
```

**Install everything**
 
```
kubectl apply -f kube
```
