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
| `hostname_short` | unset | Optional override for the short hostname. Defaults to `inventory_hostname_short`. |
| `hostname_fqdn` | unset | Optional override for the FQDN written to `/etc/hosts`. Defaults to `inventory_hostname`. |

`common_users` entries can use the following keys:

| Key | Required | Description |
| --- | --- | --- |
| `name` | yes | Local username to manage. |
| `password` | no | Plaintext password value passed through Ansible's `password_hash('sha256', 'mmmsalt')`. In practice this should come from Vault. |
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
hostname_short: monpi
hostname_fqdn: monpi.infra.example.internal
```

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
