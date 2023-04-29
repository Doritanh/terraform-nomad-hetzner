variable hcloud_token {
  description = "Hetzner token"
  sensitive = true
  type = string
}

source "hcloud" "ubuntu_22_04_arm64" {
  communicator  = "ssh"
  image         = "ubuntu-22.04"
  location      = "fsn1"
  server_type   = "cax11"
  ssh_username  = "root"
  token         = var.hcloud_token
  snapshot_name = "nomad-ubuntu-22-arm64"
  snapshot_labels = {
    "name": "nomad-ubuntu-22-arm64"
  }
}

source "hcloud" "ubuntu_22_04_x86" {
  communicator  = "ssh"
  image         = "ubuntu-22.04"
  location      = "fsn1"
  server_type   = "cx11"
  ssh_username  = "root"
  token         = var.hcloud_token
  snapshot_name = "nomad-ubuntu-22-x86"
  snapshot_labels = {
    "name": "nomad-ubuntu-22-x86"
  }
}

build {
  sources = ["source.hcloud.ubuntu_22_04_arm64", "source.hcloud.ubuntu_22_04_x86"]

  provisioner "shell" {
    inline = [
      "apt-get update && apt-get -y upgrade",
      "apt-get -y install wget gpg coreutils",
      "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      "echo 'deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main' | tee /etc/apt/sources.list.d/hashicorp.list",
      "apt-get update && apt-get -y install nomad",
      "cd /etc/nomad.d/ && nomad tls ca create"
    ]
  }
}