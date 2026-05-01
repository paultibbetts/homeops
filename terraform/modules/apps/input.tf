variable "ssh_keys" {
  description = "The SSH keys to add"
  type        = string
}

variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "network_gateway" {
  description = "The network gateway"
  type        = string
}

variable "proxmox_storage" {
  description = "The storage on the host to use"
  type        = string
}

variable "proxmox_host" {
  description = "The host to use"
  type        = string
}

variable "cloud_init_template_name" {
  description = "The cloud-init template"
  type        = string
}

variable "disk_size" {
  description = "How much disk size for apps"
  type        = string
  default     = "100G"
}

variable "cores" {
  description = "How many cores for apps"
  type        = number
  default     = 2
}
variable "memory" {
  description = "The amount of RAM"
  type        = number
  default     = 4096
}


variable "ip" {
  description = "The IP"
  type        = string
  default     = "198.51.100.23"
}
