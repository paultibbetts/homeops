# Common

Applies the baseline configuration shared by Debian/Ubuntu hosts in this repo.

## Requirements

- Debian-family managed host. The role asserts `ansible_facts.os_family == "Debian"`.
- Privilege escalation (`become: true`) because the role manages system packages, services, users, and files under `/etc`.

## Role Variables

Defaults live in `defaults/main.yaml` unless noted.

| Variable | Default | Description |
| --- | --- | --- |
| `common_default_shell` | `/bin/bash` | Default shell assigned to users in `common_users` when `shell` is not set per user. |
| `common_sudo_group` | `sudo` | Group granted sudo access for users with `sudo: true`. |
| `common_users` | `[]` | List of local users to create/manage, including SSH keys and sudo settings. |
| `common_hostname_short` | unset | Optional override for the short hostname. Defaults to `inventory_hostname_short`. |
| `common_hostname_fqdn` | unset | Optional override for the FQDN written to `/etc/hosts`. Defaults to `inventory_hostname`. |

`common_users` entries can use the following keys:

| Key | Required | Description |
| --- | --- | --- |
| `name` | yes | Local username to manage. |
| `password` | no | Plaintext password value hashed with SHA-512 and a stable per-user salt. In practice this should come from Vault. |
| `password_hash` | no | Pre-hashed password value passed directly to the user module. Preferred when you want full control over the hash. |
| `shell` | no | Per-user shell override. Defaults to `common_default_shell`. |
| `state` | no | User state, defaults to `present`. |
| `sudo` | no | If `true`, add the user to `common_sudo_group`. |
| `sudo_nopasswd` | no | If `true`, install `/etc/sudoers.d/90-<user>` granting passwordless sudo. |
| `extra_groups` | no | Additional groups to append to the user. |
| `pubkeys` | no | List of authorized SSH public keys for the user. |

## What The Role Does

- Refreshes the apt cache (`cache_valid_time: 3600`).
- Sets the system hostname and ensures a `127.0.1.1` entry exists in `/etc/hosts`.
- Installs baseline packages: `ca-certificates`, `curl`, `gnupg`, and `python3-debian`.
- Installs and enables `openssh-server`.
- Writes `/etc/ssh/sshd_config.d/10-disable-passwords.conf` to disable SSH password and challenge-response authentication, then reloads `ssh`.
- Enables `systemd-timesyncd`.
- Installs `unattended-upgrades` and writes `/etc/apt/apt.conf.d/20auto-upgrades`.
- Ensures `sudo` and the sudo group exist.
- Creates and updates users from `common_users`, authorizes SSH keys, and manages passwordless sudo snippets when requested.

## Included Task Helpers

The role also contains task files that other playbooks and roles include directly.

### `tasks/assert_container_runtime.yaml`

Validates that a container runtime command exists and, by default, supports Compose.

| Variable | Required | Default | Description |
| --- | --- | --- | --- |
| `container_runtime_command` | no | `docker` | Runtime command to check. |
| `container_runtime_needs_compose` | no | `true` | When true, also checks `<runtime> compose version`. |

### `tasks/deploy_compose_app.yaml`

Stages a Compose project directory and runs `community.docker.docker_compose_v2`.

| Variable | Required | Default | Description |
| --- | --- | --- | --- |
| `app_name` | yes | unset | Compose project name and lookup name for extra files under `ansible/files/apps/<app_name>`. |
| `app_path` | yes | unset | Project directory where `docker-compose.yaml`, `.env`, and relative volume directories are managed. |
| `compose_src` | yes | unset | Source compose file copied to `{{ app_path }}/docker-compose.yaml`. |
| `app_user` | no | `ops_user`, then `ansible_facts.user_id` | Owner for managed project files and directories. |
| `app_group` | no | `app_user`, then `ops_user`, then `ansible_facts.user_id` | Group for managed project files and directories. |
| `app_become` | no | `true` for absolute `app_path` values | Controls privilege escalation for filesystem tasks. |
| `env_template` | no | unset | Template rendered to `{{ app_path }}/.env` with mode `0600`. |
| `volume_dirs` | no | `[]` | Relative entries are created under `app_path`; absolute entries are used as-is. |
| `extra_copy_dirs` | no | `[]` | Directory names copied from `ansible/files/apps/<app_name>/`. |
| `extra_copy_files` | no | `[]` | File names copied from `ansible/files/apps/<app_name>/`. |
| `enforce_volume_ownership` | no | `false` | Recursively re-owns volume directories after Compose runs. |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  become: true
  roles:
    - role: common
```

Example variables matching the current repo pattern in `group_vars/all/main.yaml`:

```yaml
common_users:
  - name: paul
    sudo: true
    sudo_nopasswd: false
    password: "{{ vault_user_paul_password }}"
    pubkeys:
      - "ssh-ed25519 AAAA..."
```

If a host needs explicit hostname values instead of deriving them from inventory:

```yaml
common_hostname_short: monpi
common_hostname_fqdn: monpi.infra.example.internal
```

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
