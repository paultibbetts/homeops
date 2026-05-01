variable "ssh_keys" {
  description = "Authorized SSH public keys for the on-prem VM"
  type        = string
}

variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "ssh_key" {
  description = "SSH public key injected into the edge host"
  type        = string
}

variable "network_gateway" {
  description = "IPv4 gateway for the on-prem VM"
  type        = string
}

variable "proxmox_storage" {
  description = "Proxmox storage used for the on-prem VM disk"
  type        = string
}

variable "proxmox_host" {
  description = "Proxmox node that hosts the on-prem VM"
  type        = string
}

variable "cloud_init_template_name" {
  description = "Cloud-init template cloned for the on-prem VM"
  type        = string
}

variable "disk_size" {
  description = "Disk size for the on-prem tunnel VM"
  type        = string
  default     = "10G"
}

variable "cores" {
  description = "vCPU cores for the on-prem tunnel VM"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in MB for the on-prem tunnel VM"
  type        = number
  default     = 2048
}

# cloudflare

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "zone_name" {
  description = "Public DNS zone managed in Cloudflare"
  type        = string
  default     = "example.com"
}

variable "home_ip" {
  description = "IPv4 address for the on-prem tunnel VM"
  type        = string
  default     = "203.0.113.111"
}

variable "nameserver" {
  description = "Nameserver used by the on-prem tunnel VM"
  type        = string
  default     = "192.0.2.53"
}

# subdomains

variable "subdomains" {
  description = "Public subdomains that should point at the edge host"
  type        = list(string)
}
