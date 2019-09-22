data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

/* Set up cloudflare token */
variable "CLOUDFLARE_API_TOKEN" {
  type = "string"
}

resource "kubernetes_secret" "cloudflare" {
  metadata {
    name = "cloudflare-token"
  }

  type = "opaque"

  data = {
    token = var.CLOUDFLARE_API_TOKEN
  }
}

/* Provision nginx-ingress  */

resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "nginx-ingress" {
  chart      = "nginx-ingress"
  name       = "nginx-ingress"
  repository = data.helm_repository.stable.metadata.0.name
  namespace  = kubernetes_namespace.nginx-ingress.metadata.0.name
  version    = "1.21.0"

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
  }
}

resource "helm_release" "cert_manager" {
  chart      = "cert-manager"
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.metadata.0.name
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
}

