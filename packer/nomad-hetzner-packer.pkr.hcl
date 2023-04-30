variable hcloud_token {
  description = "Hetzner token"
  sensitive = true
  type = string
}

source "hcloud" "nomad_arm64" {
  communicator  = "ssh"
  image         = "debian-11"
  location      = "fsn1"
  server_type   = "cax11"
  ssh_username  = "root"
  token         = var.hcloud_token
  snapshot_name = "nomad-arm64"
  snapshot_labels = {
    "name": "nomad-arm64"
  }
}

source "hcloud" "nomad_x86" {
  communicator  = "ssh"
  image         = "debian-11"
  location      = "fsn1"
  server_type   = "cx11"
  ssh_username  = "root"
  token         = var.hcloud_token
  snapshot_name = "nomad-x86"
  snapshot_labels = {
    "name": "nomad-x86"
  }
}

build {
  sources = ["source.hcloud.nomad_arm64", "source.hcloud.nomad_x86"]

  provisioner "shell" {
    inline = [
      "apt-get update && apt-get -y upgrade",
      "apt-get -y install wget gnupg coreutils ca-certificates",
      "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      "wget -O- https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg",
      "echo 'deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bullseye main' | tee /etc/apt/sources.list.d/hashicorp.list",
      "echo 'deb [signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bullseye stable' | tee /etc/apt/sources.list.d/docker.list",
      "apt-get update && apt-get -y install docker-ce docker-ce-cli containerd.io nomad",
      "cd /etc/nomad.d/ && nomad tls ca create && nomad tls cert create -cli",
      "echo 'NOMAD_ADDR=https://localhost:4646' >> /etc/profile",
      "echo 'NOMAD_CACERT=nomad-agent-ca.pem' >> /etc/profile",
      "echo 'NOMAD_CLIENT_CERT=global-cli-nomad.pem' >> /etc/profile",
      "echo 'NOMAD_CLIENT_KEY=global-cli-nomad-key.pem' >> /etc/profile"
    ]
  }
}