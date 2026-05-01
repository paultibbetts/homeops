variable "ssh_keys" {
  description = "Authorized SSH public keys for the container"
  type        = string
}

variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "proxmox_storage" {
  description = "Proxmox storage used for the container rootfs"
  type        = string
}

variable "proxmox_host" {
  description = "Proxmox node that hosts the container"
  type        = string
}

variable "lxc_template" {
  description = "LXC template used for fresh creates"
  type        = string
  default     = null
}

variable "memory" {
  description = "Memory in MB for the container"
  type        = number
  default     = 8192
}

variable "network_gateway" {
  description = "IPv4 gateway for the container"
  type        = string
}

variable "ip" {
  description = "IPv4 address for the container"
  type        = string
  default     = "203.0.113.17"
}

variable "cores" {
  description = "vCPU cores for the container"
  type        = number
  default     = 2
}

variable "unprivileged" {
  description = "Run the container unprivileged"
  type        = bool
  default     = true
}

# Bind mount sizing is 'read only' in Proxmox, but provider requires a value.
variable "nas_mp_size" {
  description = "Dummy size for bind mount (ignored by Proxmox)"
  type        = string
  default     = "256G"
}

variable "pihole_ip" {
  description = "IPv4 address of Pi-hole, used as the nameserver"
  type        = string
  default     = "192.0.2.53"
}
