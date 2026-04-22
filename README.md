# Home Operations

This repo contains my Terraform + Ansible based "HomeProd" environment.

It's intentionally boring. It runs real workloads with real users, including myself, so I don't want it breaking.

It was decoupled from my original homelab repo, which is now a Kubernetes setup that I'm allowed to break.

> [!CAUTION]
> This is an active working repository that I'm sharing publicly. It was not designed for others to use.

> [!NOTE]
> You're welcome to steal parts you find interesting.

## Overview

| Logo | Name | Purpose |
|------|------|-------------|
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/terraform.svg" alt="Terraform" width="32"> | [Terraform](https://terraform.io/) | Server provisioning |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/ansible.svg" alt="Ansible" width="32"> | [Ansible](https://docs.ansible.com/) | Server configuration |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/proxmox.svg" alt="Proxmox" width="32"> | [Proxmox](https://www.proxmox.com/) | Virtualisation platform |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/docker.svg" alt="Docker" width="32"> | [Docker](https://www.docker.com/) | Container runtime for services |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/truenas.svg" alt="TrueNAS" width="32"> | [TrueNAS](https://www.truenas.com/) | NAS software |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/wireguard.svg" alt="Wireguard" width="32"> | [Wireguard](https://www.wireguard.com/) | VPN for private access |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/pangolin.svg" alt="Pangolin" width="32"> | [Pangolin](https://pangolin.net/) | Tunnel for public access |

## Goals

- Simple
- Stable
- Use tools I already know and understand
- Infrastructure as Code
- Let my friends and family have access to some of my services

### Non-goals

- High Availability
- Single-command setup
- Fully automated
- Recreate GitOps in Ansible
- Self-host every single service
- Create a generic homelab framework for others to use

## Ideas for the future

- [ ] test my backups
- [ ] test disaster recovery processes
- [ ] send backups to an external location (when my data starts being important enough)
- [ ] create a documentation site
- [ ] simplify the Terraform code
- [ ] replace Terraform with [OpenTofu](https://opentofu.org/)
- [ ] replace [pass](https://www.passwordstore.org/) with [SOPS](https://getsops.io/)
- [ ] add a dedicated secret manager like [Vault](https://www.hashicorp.com/en/products/vault)/[OpenBao](https://openbao.org/) or [Infisical](https://infisical.com/)
- [ ] standardise Ansible Vault usage
- [ ] use [Packer](https://developer.hashicorp.com/packer) for VM image creation
- [ ] reduce/remove manual steps for the Pangolin tunnel setup
- [ ] test new apps in my Kubernetes lab environment
- [ ] better observability - most likely the [Grafana](https://grafana.com/) "LGTM" stack
- [ ] find a Jellyfin-for-books
- [ ] add new apps and services to this repo
- [ ] decide if I should enhance/replace this setup with Kubernetes
- [ ] consider a [mesh VPN](https://tailscale.com/learn/understanding-mesh-vpns) like [Tailscale](https://tailscale.com/) or [NetBird](https://netbird.io/)
- [ ] test my backups again

## Storage

Powered by TrueNAS on a [custom NAS](hardware/nas/README.md).

### Disks

- **NVME** for apps, media and general storage
- **SSD** for TrueNAS apps and internal system data
- **HDD** for archiving and backups

#### Object storage

- S3 compatible object storage via [Minio](https://min.io/)

## Compute

Powered by Proxmox on an [Intel NUC](hardware/nuc/README.md).

### Services

| Logo | Name | Description |
|------|------|-------------|
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/caddy.svg" alt="Caddy" width="32"> | [Caddy](https://caddyserver.com/) | Reverse proxy |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/freshrss.svg" alt="FreshRSS" width="32"> | [FreshRSS](https://www.freshrss.org/) | RSS aggregator |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/gitea.svg" alt="Gitea" width="32"> | [Gitea](https://about.gitea.com) | Git repo store |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/homepage.png" alt="Homepage" width="32"> | [Homepage](https://gethomepage.dev/) | Homepage listing all my services |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/homebox.svg" alt="HomeBox" width="32"> | [HomeBox](https://homebox.software/) | Inventory management |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/jellyfin.svg" alt="Jellyfin" width="32"> | [Jellyfin](https://jellyfin.org/) | Movies and Shows |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/kanidm.svg" alt="Kanidm" width="32"> | [Kanidm](https://kanidm.com/) | Identity management |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/mealie.svg" alt="Mealie" width="32"> | [Mealie](https://mealie.io) | Recipes, meal planner, shopping list |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/mysql.svg" alt="MySQL" width="32"> | [MySQL](https://www.mysql.com/) | SQL database |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/ntfy.svg" alt="ntfy" width="32"> | [ntfy](https://ntfy.sh) | Notifications to my computers and phone |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/pi-hole.svg" alt="Pi-hole" width="32"> | [Pi-hole](https://pi-hole.net/) | Internal DNS, DHCP, and blocking ads |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/pivpn.png" alt="PiVPN" width="32"> | [PiVPN](https://pivpn.io/) | VPN setup using [Wireguard](https://www.wireguard.com/) and [Duck DNS](https://www.duckdns.org/) |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/postgres.svg" alt="Postgres" width="32"> | [Postgres](https://www.postgresql.org) | SQL database |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/renovate.svg" alt="Renovate" width="32"> | [Renovate](https://docs.renovatebot.com/) | Tracks dependencies and suggests updates |

## Monitoring

Running on a [Raspberry Pi](hardware/monpi/README.md).

### Services

| Logo | Name | Description |
|------|------|-------------|
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/uptime-kuma.svg" alt="Uptime Kuma" width="32"> | [Uptime Kuma](https://uptime.kuma.pet/) | Uptime monitoring |
| <img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/beszel-light.svg" alt="Beszel" width="32"> | [Beszel](https://www.beszel.dev/) | Server monitoring |

## Network

### Internet

500 Mbps Fibre.

### DNS

[Pi-hole](https://pi-hole.net/) running on an Ubuntu Server VM in Proxmox on the Intel NUC.

It also blocks adverts.

### LAN

[Ubiquiti Flex 10 GbE switch](https://techspecs.ui.com/unifi/switching/unifi-flex-xg?s=uk) for 10 GbE between my PC and my NAS.

[TP-Link 8 Port Managed Network Switch](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108e/) 1 GbE for everything else.

[D-Link Mesh](https://eu.dlink.com/uk/en/products/m15-eagle-pro-ai-ax1500-mesh-system) in bridge mode to connect my router to the lab.

### VPN

[Wireguard](https://www.wireguard.com/) managed by [PiVPN](https://pivpn.io/).

I am the only user.

## Tunnel

[Pangolin](https://pangolin.net/) running on a VPS.

This is mainly for sharing access with friends and family but it also lets ntfy send me notifications to my phone wherever I am.
