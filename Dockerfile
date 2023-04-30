FROM hashicorp/packer:1.8

RUN addgroup -S packer && adduser -S packer -G packer
USER packer

WORKDIR /opt/

COPY ./packer/nomad-hetzner-packer.pkr.hcl build.pkr.hcl

ENV HCLOUD_TOKEN=""

ENTRYPOINT packer build -var hcloud_token=$HCLOUD_TOKEN build.pkr.hcl