variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "ip" {
  description = "IPv4 address for the monitoring host"
  type        = string
  default     = "198.51.100.91"
}
