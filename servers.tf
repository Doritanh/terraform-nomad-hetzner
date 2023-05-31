# Template for the cloudinit file
data "template_file" "server_cloudinit_template" {
  for_each = var.nomad_servers

  template = file("${path.module}/files/cloudinit_server.tpl")

  vars = {
    hcloud_token           = "${var.hcloud_token}"
    private_ip             = "${each.value.private_ip}"
    retry_join             = "${jsonencode([for k, v in var.nomad_servers : "${v.private_ip}:4648"])}"
    bootstrap_expect       = "${length(var.nomad_servers)}"
    datacenter_name        = "${var.datacenter_name}"
    verify_server_hostname = "${var.verify_server_hostname}"
    verify_https_client    = "${var.verify_https_client}"
    client_enabled         = "${each.value.client_enabled}"
  }
}

# Transform the cloudinit template
data "template_cloudinit_config" "server_cloudinit" {
  for_each = var.nomad_servers

  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.server_cloudinit_template[each.key].rendered
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

# Define servers
resource "hcloud_server" "server" {
  for_each = var.nomad_servers

  name        = each.key
  datacenter  = each.value.datacenter
  image       = substr(each.value.server_type, 0, 3) == "cax" ? data.hcloud_image.nomad_arm64_snapshot.id : data.hcloud_image.nomad_x86_snapshot.id 
  server_type = each.value.server_type
  ssh_keys    = [
    for key in hcloud_ssh_key.ssh : key.id
  ]
  user_data   = data.template_cloudinit_config.server_cloudinit[each.key].rendered

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