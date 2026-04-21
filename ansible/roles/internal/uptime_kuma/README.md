# Uptime Kuma

Deploys Uptime Kuma as a small Docker Compose application for this repo's internal monitoring host.

This role is intentionally narrow. It stages a fixed `docker-compose.yaml`, creates the persistent data directory, and runs `docker compose up -d`. It is documented here for repo accuracy, not as a general-purpose reusable role.

## Requirements

- Docker Engine and the Compose plugin available on the target host.
- The calling playbook is expected to install Docker first. In this repo that is done with `geerlingguy.docker`.
- The shared compose deployment helper at `roles/internal/common/tasks/deploy_compose_app.yaml`.

The role validates `docker compose` availability before attempting to deploy the stack.

## Role Variables

Defaults live in `defaults/main.yaml` unless noted.

| Variable                               | Default                                       | Description                                                              |
| -------------------------------------- | --------------------------------------------- | ------------------------------------------------------------------------ |
| `uptime_kuma_app_name`                 | `uptime-kuma`                                 | Compose project name and logical app name.                               |
| `uptime_kuma_app_path`                 | `{{ apps_path }}/{{ uptime_kuma_app_name }}`  | Directory where the compose file and persistent data are stored.         |
| `uptime_kuma_enforce_volume_ownership` | `true`                                        | Recursively re-owns the persistent volume directory after Compose runs.  |
| `apps_path` (`vars/main.yaml`)          | `/srv/apps`                                   | Shared base path used by this role to build `uptime_kuma_app_path`.      |

## What The Role Deploys

- Copies [`files/docker-compose.yaml`](./files/docker-compose.yaml) to `{{ uptime_kuma_app_path }}/docker-compose.yaml`.
- Creates `{{ uptime_kuma_app_path }}/uptime-kuma-data` for persistent application data.
- Starts a single `louislam/uptime-kuma` container pinned by digest.
- Exposes the UI on host port `3001`.

The role does not currently template the Compose file or automate application-level setup. If you need different ports, image tags, or extra environment, update the bundled Compose file or extend the role.

## Dependencies

None declared in role metadata.

Operationally, Docker and the Compose plugin must already be installed before this role runs.

## Example Playbook

The repo already uses this via [`ansible/playbooks/uptime.yaml`](/Users/paul/code/homeops/ansible/playbooks/uptime.yaml:1):

```yaml
- hosts: monpi
  become: true
  roles:
    - role: geerlingguy.docker
    - role: uptime_kuma
```

Override the app root if this host stores Compose apps somewhere else:

```yaml
- hosts: monpi
  become: true
  vars:
    apps_path: /srv/www/apps
  roles:
    - role: geerlingguy.docker
    - role: uptime_kuma
```

## Check Mode

When run with `--check`, the role skips directory creation, compose file staging, and `docker compose up -d`. It only emits a reminder, so use a normal run to apply changes.

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
