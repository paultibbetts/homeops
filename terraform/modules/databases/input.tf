variable "ssh_keys" {
  description = "Authorized SSH public keys for the VMs"
  type        = string
}

variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "network_gateway" {
  description = "IPv4 gateway for the VMs"
  type        = string
}

variable "proxmox_storage" {
  description = "Proxmox storage used for the VM disks"
  type        = string
}

variable "proxmox_host" {
  description = "Proxmox node that hosts the VMs"
  type        = string
}

variable "cloud_init_template_name" {
  description = "Cloud-init template cloned for the VMs"
  type        = string
}

variable "mysql_disk_size" {
  description = "Disk size for the MySQL VM"
  type        = string
  default     = "10G"
}

variable "mysql_cores" {
  description = "vCPU cores for the MySQL VM"
  type        = number
  default     = 1
}

variable "mysql_memory" {
  description = "Memory in MB for the MySQL VM"
  type        = number
  default     = 4096
}

variable "mysql_ip" {
  description = "IPv4 address for the MySQL VM"
  type        = string
  default     = "198.51.100.61"
}

variable "postgres_disk_size" {
  description = "Disk size for the Postgres VM"
  type        = string
  default     = "10G"
}

variable "postgres_cores" {
  description = "vCPU cores for the Postgres VM"
  type        = number
  default     = 1
}

variable "postgres_memory" {
  description = "Memory in MB for the Postgres VM"
  type        = number
  default     = 4096
}

variable "postgres_ip" {
  description = "IPv4 address for the Postgres VM"
  type        = string
  default     = "203.0.113.62"
}
