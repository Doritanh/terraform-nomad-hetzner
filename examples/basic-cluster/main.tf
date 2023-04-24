module "nomad-hetzner" {
  source = "../terraform-nomad-hetzner"

  # Put your hcloud API token with read/write perms
  hcloud_token = ""

  # Put your ssh keys
  ssh_keys = ["<your ssh public key>"]

  # This is a simple configuration for nomad servers.
  nomad_servers = {
    "server-1" = {
      datacenter   = "fsn1-dc14"
      server_type  = "cax11"
      private_ip   = "10.0.1.1"
      ipv4_enabled = true
    },
    "server-2" = {
      datacenter   = "fsn1-dc14"
      server_type  = "cax11"
      private_ip   = "10.0.1.2"
      ipv4_enabled = false
    },
    "server-3" = {
      datacenter   = "fsn1-dc14"
      server_type  = "cax11"
      private_ip   = "10.0.1.3"
      ipv4_enabled = false
    }
  }
}