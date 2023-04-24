data "template_file" "worker_init" {
  template = file("${path.module}/files/cloudinit_worker.tpl")

  vars = {
    hcloud_token = "${var.hcloud_token}"
  }
}

data "template_cloudinit_config" "worker_config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.worker_init.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = "baz"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "ffbaz"
  }
}

resource "hcloud_server" "worker" {
  for_each = var.nomad_workers

  name        = each.key
  datacenter  = each.value.datacenter
  image       = "ubuntu-22.04"
  server_type = each.value.server_type
  ssh_keys    = [
    for obj in hcloud_ssh_key.ssh : obj.id
  ]
  user_data   = data.template_cloudinit_config.worker_config.rendered

  public_net {
    ipv4_enabled = each.value.ipv4_enabled
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.net.id
    ip         = each.value.private_ip
  }

  placement_group_id = hcloud_placement_group.placement_group.id
  firewall_ids       = [hcloud_firewall.firewall.id]

  depends_on = [
    hcloud_network_subnet.net,
    hcloud_firewall.firewall
  ]
}