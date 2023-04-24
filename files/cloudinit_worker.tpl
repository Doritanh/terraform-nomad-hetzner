#cloud-config
apt:
  sources:
    docker.list:
      source: 'deb [signed-by=$KEY_FILE] https://download.docker.com/linux/ubuntu $RELEASE stable'
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        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
        YT90qFF93M3v01BbxP+EIY2/9tiIPbrd
        =0YYh
        -----END PGP PUBLIC KEY BLOCK-----
    hashicorp.list:
      source: 'deb [signed-by=$KEY_FILE] https://apt.releases.hashicorp.com $RELEASE main'
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        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
        =FdUF
        -----END PGP PUBLIC KEY BLOCK-----
package_update: true
package_upgrade: true
packages:
  - docker
  - nomad
write_files:
- content: |
    # Nomad configuration file

    data_dir = "/opt/nomad/data"
    bind_addr = "0.0.0.0"
    datacenter = "dc1"
    
    client {
      enabled = true
      servers = ["10.0.1.1:4647", "10.0.1.2:4647", "10.0.1.3:4647"]
    }
  path: /etc/nomad.d/nomad.hcl
  owner: root:root
runcmd:
  - [systemctl, enable, docker]
  - [systemctl, start, docker]
  - [systemctl, enable, nomad]
  - [systemctl, start, nomad]
