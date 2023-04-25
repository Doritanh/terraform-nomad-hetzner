# Template for the cloudinit file
data "template_file" "client_cloudinit_template" {
  for_each = var.nomad_clients

  template = file("${path.module}/files/cloudinit_client.tpl")

  vars = {
    hcloud_token    = "${var.hcloud_token}"
    private_ip      = "${each.value.private_ip}"
    servers         = "${jsonencode([for k, v in var.nomad_servers : "${v.private_ip}:4647"])}"
    datacenter_name = "${var.datacenter_name}"
  }
}

# Transform the cloudinit template
data "template_cloudinit_config" "client_cloudinit" {
  for_each = var.nomad_clients

  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.client_cloudinit_template[each.key].rendered
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

# Define clients
resource "hcloud_server" "client" {
  for_each = var.nomad_clients

  name        = each.key
  datacenter  = each.value.datacenter
  image       = "ubuntu-22.04"
  server_type = each.value.server_type
  ssh_keys    = [
    for key in hcloud_ssh_key.ssh : key.id
  ]
  user_data   = data.template_cloudinit_config.client_cloudinit[each.key].rendered

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