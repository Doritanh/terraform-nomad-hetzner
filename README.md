<div align="center">
  <h3 align="center">Nomad Hetzner</h3>

  <p align="center">
    This repository contains Terraform code to easily deploy a Nomad infrastructure on Hetzner.
    Use this code to deploy and manage your Nomad cluster on Hetzner with ease.
    <br />
    <a href="https://github.com/github_username/repo_name"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/github_username/repo_name">View Demo</a>
    ·
    <a href="https://github.com/github_username/repo_name/issues">Report Bug</a>
    ·
    <a href="https://github.com/github_username/repo_name/issues">Request Feature</a>
  </p>
</div>


## About the Project

This project is designed to help you deploy a very cheap and lightweight Nomad cluster using Terraform on Hetzner Cloud. With this setup, you'll be able to easily spin up and manage a cluster of Nomad servers and clients, allowing you to run your applications and workloads with ease.

By leveraging the power of Terraform, you can quickly and easily deploy your Nomad cluster to Hetzner Cloud, using pre-configured templates and best practices to ensure your setup is optimized for performance, reliability, and security.

## Getting Started

### Prerequisites

Before you can deploy this Nomad cluster, you must have the following:

- A Hetzner Cloud Account
- A Hetzner Cloud Token 
- Terraform installed on your local computer
- Docker or Packer, to create the base images on Hetzner

You need to configure the snapshots on Hetzner Cloud. This is done with packer, and you can find the configuration file in [./packer](https://github.com/nomad-hetzner/terraform-nomad-hetzner/blob/main/packer/nomad-hetzner-packer.pkr.hcl). This repo configure this file in a dockerfile so that you can just create all the resource with a single line.

With Docker
```shell
docker run --rm -e HCLOUD_TOKEN=<your token> ghcr.io/nomad-hetzner/terraform-nomad-hetzner:main
```

With Packer
```shell
wget https://raw.githubusercontent.com/nomad-hetzner/terraform-nomad-hetzner/main/packer/nomad-hetzner-packer.pkr.hcl
packer build -var hcloud_token=<your token> nomad-hetzner-packer.pkr.hcl
```

### Usage

You can copy the folder examples/basic-cluster on your local machine. Then you can customize the variables depending on your needs.

Then you will have to run the following terraform commands.
```shell
terraform init
terraform plan
terraform apply
```

If you want to destroy anything, you can run `terraform destroy`.

# Licence
This repository is licensed under the MIT license. See the LICENSE file for more information.