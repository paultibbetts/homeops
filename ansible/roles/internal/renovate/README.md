# Renovate

Runs Renovate as a scheduled one-shot Docker container managed by systemd.

The role renders a Renovate `config.js`, writes an env file containing API credentials, installs a systemd service and timer, reloads systemd when those unit files change, and enables the timer.

## Requirements

- Docker available on the target host at `renovate_docker_binary` (default: `/usr/bin/docker`).
- systemd available on the target host.
- A Renovate platform token provided via `renovate_token`, typically from Vault.

This role does not declare a Docker role dependency in `meta/main.yaml`; in this repo the playbook handles that by applying `geerlingguy.docker` before `renovate`.
The role validates Docker CLI availability before installing the service and timer.

## Role Variables

Defaults live in `defaults/main.yaml`.

| Variable | Default | Description |
| --- | --- | --- |
| `renovate_service_name` | `renovate` | Base name for the systemd service unit. |
| `renovate_timer_name` | `{{ renovate_service_name }}.timer` | Name of the systemd timer unit. |
| `renovate_root_dir` | `/opt/renovate` | Directory containing the rendered Renovate config and env file. |
| `renovate_config_path` | `{{ renovate_root_dir }}/config.js` | Host path for the rendered Renovate config. |
| `renovate_env_path` | `{{ renovate_root_dir }}/env` | Host path for the environment file passed to `docker run --env-file`. |
| `renovate_docker_binary` | `/usr/bin/docker` | Docker CLI binary used by the systemd service. |
| `renovate_docker_image` | `ghcr.io/renovatebot/renovate:latest` | Container image used for Renovate runs. |
| `renovate_container_config_path` | `/usr/src/app/config.js` | Mount path for the rendered config inside the Renovate container. |
| `renovate_timeout_start_sec` | `6h` | `TimeoutStartSec` for the systemd service. |
| `renovate_platform` | `gitea` | Renovate platform value written to `config.js`. |
| `renovate_endpoint` | required | API endpoint for the configured platform. |
| `renovate_token` | required | Platform token used to authenticate to the configured platform. |
| `renovate_git_author` | `Renovate Bot <bot@renovateapp.com>` | Git author used by Renovate commits. |
| `renovate_autodiscover` | `true` | If true, let Renovate autodiscover repositories for the token. |
| `renovate_dependency_dashboard` | `true` | Enable Renovate dependency dashboard issues. |
| `renovate_prune_stale_branches` | `true` | Let Renovate prune stale update branches. |
| `renovate_onboarding` | `true` | Enable onboarding PR/config flow. |
| `renovate_repositories` | `[]` | Explicit repository list. Only rendered when `renovate_autodiscover: false`. |
| `renovate_pr_hourly_limit` | `10` | `prHourlyLimit` in the rendered config. |
| `renovate_labels` | `[dependencies]` | Labels applied to Renovate PRs. |
| `renovate_patch_grouping_enabled` | `true` | When true, render a package rule that groups patch updates under `patches`. |
| `renovate_dockerhub_username` | required | Docker Hub username used for host rules. |
| `renovate_dockerhub_token` | required | Docker Hub token exposed to the container. |
| `renovate_github_com_token` | `{{ vault_github_com_token | default('') }}` | Optional GitHub token exposed to the container as `RENOVATE_GITHUB_COM_TOKEN`. |
| `renovate_timer_on_calendar` | `daily` | systemd timer schedule. |
| `renovate_timer_persistent` | `true` | Whether missed runs should execute after boot. |

## What The Role Deploys

- Creates `{{ renovate_root_dir }}`.
- Renders `config.js` from [`ansible/roles/internal/renovate/templates/config.js.j2`](./templates/config.js.j2).
- Writes an env file containing:
  - `RENOVATE_TOKEN`
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN`
  - `RENOVATE_GITHUB_COM_TOKEN`
- Installs:
  - `/etc/systemd/system/{{ renovate_service_name }}.service`
  - `/etc/systemd/system/{{ renovate_timer_name }}`
- Enables and starts the timer.

The service runs Renovate with:

```text
docker run --rm --env-file <env> --volume <config>:<container-config>:ro <image>
```

The current unit file does not mount a Docker socket or repo checkout directory; it relies on Renovate's normal platform API flow rather than local repository access.

## Dependencies

None declared in role metadata.

Operationally, Docker and systemd must already be available before this role runs.

## Example Playbook

The repo already uses this via [`ansible/playbooks/renovate.yaml`](../../../playbooks/renovate.yaml):

```yaml
- hosts: apps
  gather_facts: true
  become: true
  roles:
    - role: geerlingguy.docker
    - role: renovate
```

Example variables for the default Gitea-backed setup:

```yaml
renovate_endpoint: https://gitea.example.com/api/v1/
renovate_token: "{{ vault_renovate_token }}"
renovate_dockerhub_username: your-dockerhub-username
renovate_dockerhub_token: "{{ vault_dockerhub_token }}"
renovate_github_com_token: "{{ vault_github_com_token }}"
```

If you want to disable autodiscovery and target a fixed repo list:

```yaml
renovate_autodiscover: false
renovate_repositories:
  - paultibbetts/homeops
  - paultibbetts/some-other-repo
```

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
