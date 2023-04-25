# Configure the hcloud token.
# This will allow to access the hcloud project.
provider "hcloud" {
  token = var.hcloud_token
}

# Create the SSH keys
resource "hcloud_ssh_key" "ssh" {
  count      = length(var.ssh_keys)
  name       = count.index
  public_key = var.ssh_keys[count.index]
}

resource "hcloud_network" "net" {
  name     = "Nomad Network"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "net" {
  network_id   = hcloud_network.net.id
  type         = "server"
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/8"
}

resource "hcloud_firewall" "firewall" {
  name = "Nomad Firewall"

  rule {
    description = "Allow ICMP In"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description = "Allow SSH In"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description = "Allow Nomad UI In"
    direction   = "in"
    protocol    = "tcp"
    port        = "4646"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

}

resource "hcloud_placement_group" "placement_group" {
  name = "Nomad Placement Group"
  type = "spread"
}