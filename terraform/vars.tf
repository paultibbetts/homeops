## Provider

### Hetzner

variable "hetzner_api_token" {
  description = "Hetzner API token"
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "The SSH key of the ops user"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5cSqQNVmTIWz9901r8HB+DiwmnFYRWYXChyqigkzAA"
}

### Proxmox

variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "If the API is insecure"
  type        = bool
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

# Cloudflare

variable "cloudflare_api_token_public_zone" {
  type      = string
  sensitive = true
}

## Global

variable "internal_dns_zone" {
  description = "Private DNS zone used for internal service records"
  type        = string
  default     = "infra.example.internal"
}

variable "ssh_keys" {
  description = "The SSH keys to add"
  type        = string
  default     = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLiEeOqR0KLdVZ64p94nk2fSno1jyminStrv2OPVcd2 ops@example.com
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfx70ArvHPF+9U3GgKgNEAWkXSyZMun83sn9582Pl4e ops@example.com
    EOT
}

variable "network_gateway" {
  description = "The network gateway"
  type        = string
  default     = "198.51.100.1"
  validation {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.network_gateway))
    error_message = "The network_gateway value must be a valid IP."
  }
}

variable "apps_ip" {
  description = "IPv4 address for the apps VM"
  type        = string
  default     = "198.51.100.23"
}

variable "auth_ip" {
  description = "IPv4 address for the auth VM"
  type        = string
  default     = "203.0.113.42"
}

variable "dns_ip" {
  description = "IPv4 address for the DNS VM"
  type        = string
  default     = "192.0.2.53"
}

variable "mysql_ip" {
  description = "IPv4 address for the MySQL VM"
  type        = string
  default     = "198.51.100.61"
}

variable "postgres_ip" {
  description = "IPv4 address for the Postgres VM"
  type        = string
  default     = "203.0.113.62"
}

variable "gitea_ip" {
  description = "IPv4 address for the Gitea VM"
  type        = string
  default     = "192.0.2.44"
}

variable "ingress_ip" {
  description = "IPv4 address for the ingress VM"
  type        = string
  default     = "198.51.100.80"
}

variable "jellyfin_ip" {
  description = "IPv4 address for the Jellyfin host"
  type        = string
  default     = "203.0.113.17"
}

variable "artpi_ip" {
  description = "IPv4 address for the artpi host"
  type        = string
  default     = "192.0.2.90"
}

variable "monitoring_ip" {
  description = "IPv4 address for the monitoring host"
  type        = string
  default     = "198.51.100.91"
}

variable "tunnel_home_ip" {
  description = "IPv4 address for the on-prem tunnel VM"
  type        = string
  default     = "203.0.113.111"
}

## Proxmox

variable "proxmox_host" {
  description = "The proxmox host to apply to"
  type        = string
  default     = "host1"
}

variable "proxmox_storage" {
  description = "The storage on the host to use"
  type        = string
  default     = "vms"
}

### Proxmox cloud-init VM

variable "cloud_init_template_name" {
  description = "The cloud-init template to clone from"
  type        = string
  default     = "ubuntu-2404-cloudinit-template"
}

### Proxmox LXC

variable "lxc_template" {
  description = "The LXC template to clone from"
  type        = string
  default     = "vms:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}

## Pi-hole

variable "pihole_admin_password" {
  description = "The admin password for Pi-hole"
  type        = string
  sensitive   = true
}

variable "public_zone_tunnel_subdomains" {
  type = list(string)
}

variable "cloudflare_zone_name" {
  description = "Public DNS zone managed by the tunnel module"
  type        = string
  default     = "example.com"
}
