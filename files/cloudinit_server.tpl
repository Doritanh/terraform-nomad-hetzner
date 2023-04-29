#cloud-config
write_files:
- content: |
    # Nomad configuration file

    data_dir = "/opt/nomad/data"
    bind_addr = "0.0.0.0"
    datacenter = "${datacenter_name}"

    advertise {
      http = "0.0.0.0"
      rpc  = "${private_ip}"
      serf = "${private_ip}"
    }
    
    server {
      enabled = true
      bootstrap_expect = ${bootstrap_expect}
      server_join {
        retry_join = ${retry_join}
      }
    }

    tls {
      http = false
      rpc  = true

      ca_file   = "/etc/nomad.d/nomad-agent-ca.pem"
      cert_file = "/etc/nomad.d/global-server-nomad.pem"
      key_file  = "/etc/nomad.d/global-server-nomad-key.pem"

      verify_server_hostname = true
      verify_https_client    = true
    }
  path: /etc/nomad.d/nomad.hcl
  owner: root:root
runcmd:
  - [cd, /etc/nomad.d/]
  - [nomad, tls, cert, create, -server, -region, global]
  - [systemctl, enable, nomad]
  - [systemctl, start, nomad]
