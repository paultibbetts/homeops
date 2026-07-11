terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.22.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.66"
    }
    pihole = {
      source  = "lukaspustina/pihole"
      version = "0.3.1"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc08"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
