#cloud-config
write_files:
- content: |
    # Nomad configuration file

    data_dir = "/opt/nomad/data"
    bind_addr = "0.0.0.0"
    datacenter = "${datacenter_name}"

    advertise {
      http = "${private_ip}"
      rpc  = "${private_ip}"
      serf = "${private_ip}"
    }
    
    client {
      enabled = true
      servers = ${servers}
    }
    
    tls {
      http = true
      rpc  = true

      ca_file   = "/etc/nomad.d/nomad-agent-ca.pem"
      cert_file = "/etc/nomad.d/global-client-nomad.pem"
      key_file  = "/etc/nomad.d/global-client-nomad-key.pem"

      verify_server_hostname = true
      verify_https_client    = true
    }
  path: /etc/nomad.d/nomad.hcl
  owner: root:root
runcmd:
  - [cd, /etc/nomad.d/]
  - [nomad, tls, cert, create, -client]
  - [systemctl, enable, docker]
  - [systemctl, start, docker]
  - [systemctl, enable, nomad]
  - [systemctl, start, nomad]
