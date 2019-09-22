provider "digitalocean" {}

provider "kubernetes" {
  host = digitalocean_kubernetes_cluster.lavatoaster.endpoint

  client_certificate     = base64decode(digitalocean_kubernetes_cluster.lavatoaster.kube_config.0.client_certificate)
  client_key             = base64decode(digitalocean_kubernetes_cluster.lavatoaster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.lavatoaster.kube_config.0.cluster_ca_certificate)
}

resource "random_uuid" "lavatoaster_pool_1" { }

resource "digitalocean_kubernetes_cluster" "lavatoaster" {
  name = "lavatoaster"
  region = "lon1"
  version = "1.15.3-do.2"

  node_pool {
    name = "node-pool-${random_uuid.lavatoaster_pool_1.result}"
    node_count = 2
    size = "s-1vcpu-2gb"
  }
}
