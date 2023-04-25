terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.38.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}