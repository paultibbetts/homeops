# HomeOps

Self-hosting at home.

## NAS

[Hardware](hardware/nas/README.md)

### Storage

- **NVME** for apps, media and general storage
- **SSD** for internal purposes
- **HDD** for archiving and backups

#### Object storage

- S3 compatible object storage via [Minio](https://min.io/)

## NUC

[Hardware](hardware/nuc/README.md)

### Apps

- **Ad Block / DNS** - [PiHole](https://pi-hole.net/)
- **VPN** - [PiVPN](https://pivpn.io/) ([Wireguard](https://www.wireguard.com/))
- **Auth** - [Kanidm](https://kanidm.com/)
- **Git** - [Gitea](https://about.gitea.com/)
- **RSS** - [FreshRSS](https://www.freshrss.org/)
- **Dashboard** [Homepage](https://gethomepage.dev/)
- **Recipe Management** [Mealie](https://mealie.io/)
- **Inventory Management** [HomeBox](https://homebox.software/)
- **Databases** - [MySQL](https://www.mysql.com/) and [Postgres](https://www.postgresql.org/)
- **Movies & Shows** - [Jellyfin](https://jellyfin.org/)
- **Ingress** - [Caddy](https://caddyserver.com/)
- **Notifications** - [ntfy](https://ntfy.sh/)
- **Dependency updates** - [Renovate](https://docs.renovatebot.com/)

## MonPi

[Hardware](hardware/monpi/README.md)

### Apps

- **Uptime** - [Uptime Kuma](https://uptime.kuma.pet/)
- **Monitoring** - [Beszel](https://www.beszel.dev/)

## Network

### Internet

500 Mbps Fibre

### DNS

[Pi-hole](https://pi-hole.net/) running on an Ubuntu Server VM in Proxmox on the Intel NUC.

It also blocks adverts.

### LAN

[Ubiquiti Flex 10 GbE](https://techspecs.ui.com/unifi/switching/unifi-flex-xg?s=uk)

[TP-Link Managed Network Switch 8 Port Gigabit](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108e/)

[D-Link Mesh](https://eu.dlink.com/uk/en/products/m15-eagle-pro-ai-ax1500-mesh-system) in bridge mode.

### VPN

[Wireguard](https://www.wireguard.com/) installed on an Ubuntu Server VM in Proxmox on the Intel NUC.
