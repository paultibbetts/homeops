terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.4.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.60"
    }
    pihole = {
      source  = "lukaspustina/pihole"
      version = "0.3.1"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "homeops.tfstate"
    region                      = "main" # region validation will be skipped
    skip_credentials_validation = true   # Skip AWS related checks and validations
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true # Enable path-style S3 URLs (https://<HOST>/<BUCKET> https://developer.hashicorp.com/terraform/language/settings/backends/s3#use_path_style
  }
}

module "dns" {
  source = "./modules/dns"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  pihole_ip                = var.dns_ip
}

module "databases" {
  source = "./modules/databases"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  mysql_ip                 = var.mysql_ip
  postgres_ip              = var.postgres_ip
}

module "gitea" {
  source = "./modules/gitea"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  ip                       = var.gitea_ip
}

module "ingress" {
  source = "./modules/ingress"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  ip                       = var.ingress_ip
}

module "auth" {
  source = "./modules/auth"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  ip                       = var.auth_ip
}

module "jellyfin" {
  source = "./modules/jellyfin"

  internal_dns_zone = var.internal_dns_zone
  ssh_keys        = var.ssh_keys
  network_gateway = var.network_gateway
  proxmox_storage = var.proxmox_storage
  proxmox_host    = var.proxmox_host
  lxc_template    = var.lxc_template # optional; not used post-import
  ip              = var.jellyfin_ip
  pihole_ip       = var.dns_ip

  # Jellyfin specifics
  memory       = 8192
  cores        = 2
  unprivileged = true
}

module "vpn" {
  source = "./modules/vpn"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
}

module "tunnel" {
  source = "./modules/tunnel"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys # deprecated
  ssh_key                  = var.ssh_key
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  network_gateway          = var.network_gateway
  home_ip                  = var.tunnel_home_ip
  nameserver               = var.dns_ip

  cloudflare_api_token = var.cloudflare_api_token_public_zone
  zone_name            = var.cloudflare_zone_name
  subdomains           = var.public_zone_tunnel_subdomains
}


module "apps" {
  source = "./modules/apps"

  internal_dns_zone        = var.internal_dns_zone
  ssh_keys                 = var.ssh_keys
  network_gateway          = var.network_gateway
  proxmox_storage          = var.proxmox_storage
  proxmox_host             = var.proxmox_host
  cloud_init_template_name = var.cloud_init_template_name
  ip                       = var.apps_ip
}

module "monitoring" {
  source = "./modules/monitoring"

  internal_dns_zone = var.internal_dns_zone
  ip                = var.monitoring_ip
}

module "artpi" {
  source = "./modules/artpi"

  internal_dns_zone = var.internal_dns_zone
  ip                = var.artpi_ip
}
