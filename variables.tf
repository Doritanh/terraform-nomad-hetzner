variable "hcloud_token" {
  type        = string
  description = "The hcloud API read/write token"
  sensitive   = true
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH keys"
  default     = []
}

variable "nomad_servers" {
  type = map(object({
    datacenter   = string
    server_type  = string
    private_ip   = string
    ipv4_enabled = bool
  }))
  description = "List of the nomad servers"
}

variable "nomad_workers" {
  type = map(object({
    datacenter   = string
    server_type  = string
    private_ip   = string
    ipv4_enabled = bool
  }))
  description = "List of the nomad workers"
}