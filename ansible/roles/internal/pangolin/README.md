# Pangolin

Configures a single-node Pangolin stack (Pangolin + Traefik + optional Gerbil/CrowdSec/GeoIP).

This role is focused on:

- Rendering config into `pangolin_project_dir` (default: `/srv/pangolin`)
- Bringing the stack up via `docker compose up -d` when config changes

## Requirements

- Container runtime already installed on the target host.
- Compose support:
  - Docker: `docker compose` (in this repo typically installed via `geerlingguy.docker` in the calling playbook)
  - Podman: `podman compose` (only relevant if you switch `pangolin_runtime`)
- `curl` available (used by container healthchecks)

The role validates the selected runtime (`docker` or `podman`) and checks that compose support is available before applying the stack.

## Role Variables

See `defaults/main.yaml` for the full list. The key variables are:

**Required**

- `pangolin_base_domain`: Base domain used by Pangolin.
- `pangolin_dashboard_domain`: Public hostname for the Pangolin dashboard (Traefik routes + app URLs).
- `pangolin_letsencrypt_email`: ACME email for Traefik.
- `pangolin_server_secret`: Pangolin server secret used for signing/session security.

**Runtime / lifecycle**

- `pangolin_runtime`: `docker` (default) or `podman`.
- `pangolin_edition`: `community` (default) or `enterprise`.
- `pangolin_project_dir`: Base directory for the compose project (default: `/srv/pangolin`).
- `pangolin_owner_user` / `pangolin_owner_group`: Ownership for rendered files/dirs (default: `ops`/`ops`).
- `pangolin_apply_compose`: If `true` (default), apply changes with `docker compose up -d --remove-orphans`.

**Images**

- `pangolin_image`, `pangolin_gerbil_image`, `pangolin_traefik_image`, `pangolin_crowdsec_image`, `pangolin_geoipupdate_image`

Use full image references. Prefer `repository:tag@sha256:digest` for deployed
inventory values once the stack has been upgraded through any required upstream
stages. The legacy `*_image_tag` variables still exist as compatibility
fallbacks for the role defaults, but new inventory should override the full
image variables instead.

**Features**

- `pangolin_install_gerbil`: Expose ports via Gerbil container (default: `true`).
- `pangolin_enable_crowdsec`: Enable Traefik CrowdSec bouncer + CrowdSec container (default: `false`).
- `pangolin_enable_geoblocking`: Enable MaxMind GeoLite2 database updates (default: `false`).
- `pangolin_enable_integration_api`: Expose Pangolin Integration API via Traefik (default: `false`).
- `pangolin_badger_plugin_version`: Badger Traefik plugin version.
- `pangolin_crowdsec_bouncer_plugin_version`: CrowdSec Traefik bouncer plugin version.

**Pangolin app config (opinionated defaults, overridable)**

- `pangolin_app_log_level`: `info` by default.
- `pangolin_domain_cert_resolver`: Traefik certificate resolver for the configured Pangolin domain (`letsencrypt` by default).
- `pangolin_telemetry_anonymous_usage`: `true` by default.
- `pangolin_disable_signup_without_invite`: `true` by default.
- `pangolin_disable_user_create_org`: `false` by default.
- `pangolin_allow_raw_resources`: `true` by default.
- `pangolin_disable_enterprise_features`: `false` by default. Rendered only
  when `pangolin_image_is_community_edition` is true.
- `pangolin_private_config`: `{}` by default. When `pangolin_edition:
  enterprise` and this dict is non-empty, it is rendered to
  `config/privateConfig.yml` for Enterprise-only settings.
- `pangolin_image_is_community_edition`: inferred from `pangolin_edition`.

**Enterprise Edition**

Set `pangolin_edition: enterprise` and update `pangolin_image` to the
Enterprise image tag. Keeping a single `pangolin_image` override means Renovate
only tracks the active edition image in inventory.

Enterprise licensing is activated in the Pangolin UI. After deploying the
Enterprise image, log in as a server admin and activate the license at
`/admin/license`. The role does not template a license key because Pangolin's
published self-hosting docs currently document UI activation rather than an
environment variable or `config.yml` key.

**Secrets (store in Vault)**

- `pangolin_maxmind_account_id`, `pangolin_maxmind_license_key` (required when `pangolin_enable_geoblocking: true`)
- `pangolin_crowdsec_lapi_key` (required for CrowdSec bouncer)

Notes:

- When `pangolin_enable_geoblocking: true`, the role writes MaxMind credentials to `pangolin_env_file_path` and starts `geoipupdate`.
- When `pangolin_enable_crowdsec: true`, the role renders Traefik plugin config that includes the CrowdSec LAPI key.

## Dependencies

None declared in role metadata.

Operationally, the selected container runtime must already be installed before this role runs.

## Example Playbook

**Standard setup (minimal)**

This brings up Pangolin + Traefik + Gerbil with LetsEncrypt, without CrowdSec/GeoIP:

```yaml
- hosts: tunnel
  become: true
  roles:
    - role: geerlingguy.docker
    - role: pangolin
  vars:
    pangolin_base_domain: "example.com"
    pangolin_dashboard_domain: "pangolin.example.com"
    pangolin_letsencrypt_email: "me@example.com"
    pangolin_server_secret: "{{ vault_pangolin_server_secret }}"

    pangolin_image: "docker.io/fosrl/pangolin:1.10.0@sha256:..."
    pangolin_gerbil_image: "docker.io/fosrl/gerbil:1.10.0@sha256:..."
    pangolin_traefik_image: "docker.io/traefik:3.3.6@sha256:..."
    pangolin_install_gerbil: true
```

**Custom setup (optional features)**

Enable CrowdSec and GeoIP updates (store credentials in Vault):

```yaml
- hosts: tunnel
  become: true
  roles:
    - role: geerlingguy.docker
    - role: pangolin
  vars:
    pangolin_enable_crowdsec: true
    pangolin_crowdsec_lapi_key: "{{ vault_pangolin_crowdsec_lapi_key }}"

    pangolin_enable_geoblocking: true
    pangolin_maxmind_account_id: "{{ vault_pangolin_maxmind_account_id }}"
    pangolin_maxmind_license_key: "{{ vault_pangolin_maxmind_license_key }}"

    pangolin_env_extra:
      GEOIPUPDATE_EDITION_IDS: "GeoLite2-Country GeoLite2-ASN"
      GEOIPUPDATE_FREQUENCY: "72"
```

Initial Pangolin application setup (creating the first admin user/org/site, configuring SSO/IDPs, etc.) is intentionally not automated by this role; do it via the UI/API after the stack is running.

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
