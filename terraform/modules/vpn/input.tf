variable "ssh_keys" {
  description = "Authorized SSH public keys for the VM"
  type        = string
}

variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "proxmox_storage" {
  description = "Proxmox storage used for the VM disk"
  type        = string
}

variable "proxmox_host" {
  description = "Proxmox node that hosts the VM"
  type        = string
}

variable "cloud_init_template_name" {
  description = "Cloud-init template cloned for the VM"
  type        = string
}

variable "disk_size" {
  description = "Disk size for the VPN VM"
  type        = string
  default     = "10G"
}

variable "cores" {
  description = "vCPU cores for the VPN VM"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in MB for the VPN VM"
  type        = number
  default     = 2048
}

variable "ip" {
  description = "IPv4 address for the VPN VM"
  type        = string
  default     = "192.0.2.3"
}

variable "network_gateway" {
  description = "IPv4 gateway for the on-prem VM"
  type        = string
}

variable "nameserver" {
  description = "Nameserver used by the on-prem tunnel VM"
  type        = string
  default     = "192.0.2.53"
}
