terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "lavoaster"

    workspaces {
      name = "infra"
    }
  }
}
