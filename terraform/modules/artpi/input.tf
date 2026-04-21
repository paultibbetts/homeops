variable "internal_dns_zone" {
  description = "Private DNS zone used for generated hostnames"
  type        = string
}

variable "ip" {
  description = "IPv4 address for the artpi host"
  type        = string
  default     = "192.0.2.90"
}
