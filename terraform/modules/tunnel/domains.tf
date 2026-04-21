locals {
  home = {
    fqdn = "tunnel.${var.internal_dns_zone}"
    ip   = var.home_ip
  }
  edge = {
    name = "pangolin.hcloud"
    host = hcloud_server.edge.ipv4_address
  }
}

resource "ansible_host" "home" {
  name   = local.home.fqdn
  groups = ["tunnel", "site_home"]
  variables = {
    ansible_host = local.home.ip
    ansible_user = "ops"
  }
}

resource "pihole_dns_record" "home" {
  domain = local.home.fqdn
  ip     = local.home.ip
}

resource "ansible_host" "edge" {
  name   = local.edge.name
  groups = ["tunnel", "site_edge"]
  variables = {
    ansible_host = local.edge.host
    ansible_user = "ops"
  }
}

data "cloudflare_zones" "public" {
  name = var.zone_name
}

locals {
  subdomains = toset(var.subdomains)
}

resource "cloudflare_dns_record" "a" {
  for_each = local.subdomains

  zone_id = data.cloudflare_zones.public.result[0].id
  name    = each.value
  type    = "A"
  content = local.edge.host

  ttl     = 1
  proxied = false
}
