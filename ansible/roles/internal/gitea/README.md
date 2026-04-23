# Gitea

Installs Gitea from the upstream standalone binary and manages it as a Linux service.

This role follows the same general shape as Gitea's binary-install and Linux service documentation: create a dedicated service account, download the release binary, write a small environment file, install a service definition, and start the service. In this repo, the role is intentionally narrower than the full upstream install guide and leaves application configuration, database preparation, and reverse proxying to other parts of the stack.

## Requirements

- Linux host with either `systemd` or SysV init.
- Network access to the Gitea download host used by `gitea_download_url`.
- `git` already installed on the target host. Current official Gitea install docs still call Git out as a prerequisite for binary installs.
- Any required database, DNS, TLS, and reverse proxy setup handled elsewhere.

Notes:

- The role installs `ca-certificates`, but it does not install Git itself.
- The role does not verify the downloaded binary with GPG, even though Gitea's installation guide recommends signature verification.

## Role Variables

Defaults live in `defaults/main.yaml` unless noted.

| Variable | Default | Description |
| --- | --- | --- |
| `gitea_version` | `1.21.7` | Gitea version to download. |
| `gitea_binary` | `/home/gitea/bin/gitea` | Path where the Gitea binary is installed. |
| `gitea_env_file` | `/etc/default/gitea` | Environment file consumed by the service unit/init script. |
| `gitea_working_directory` | `/home/gitea` | Gitea working directory and home path used by the service. |
| `gitea_user` | `git` | Runtime user for the Gitea service. |
| `gitea_group` | `git` | Runtime group for the Gitea service. |

Additional role variables are defined in `vars/main.yaml` and are effectively internal implementation details:

| Variable | Default | Description |
| --- | --- | --- |
| `gitea_download_url` | derived from version, OS, and architecture | Download URL for the release binary. |
| `gitea_initd_conf_dir` | `/etc/init.d` | Destination for the SysV init script when `systemd` is not used. |
| `gitea_systemd_units_dir` | `/lib/systemd/system` | Destination for the systemd unit file. |
| `gitea_support_packages` | `[ca-certificates, git]` | Small package list installed before downloading the binary. |

## What The Role Does

- Installs the packages listed in `gitea_support_packages`.
- Creates the Gitea group and user.
- Ensures the parent directory of `gitea_binary` exists and is owned by the Gitea user/group.
- Downloads the Gitea binary from `gitea_download_url`.
- Renders [`ansible/roles/internal/gitea/templates/gitea.env.j2`](./templates/gitea.env.j2) to `gitea_env_file`.
- Installs either:
  - a systemd unit at `{{ gitea_systemd_units_dir }}/gitea.service`, or
  - a SysV init script at `{{ gitea_initd_conf_dir }}/gitea`
- Renders an update helper script to `{{ gitea_working_directory }}/bin/update.sh`.
- Enables and starts the `gitea` service.

## What The Role Does Not Do

- It does not install Git.
- It does not template or manage `/etc/gitea/app.ini`.
- It does not create Gitea's full upstream-recommended directory layout under `/var/lib/gitea` and `/etc/gitea`.
- It does not prepare the database or manage external database users.
- It does not configure a reverse proxy, TLS, SSH exposure, backups, or initial application setup.

That means first-run application configuration is expected to happen outside this role, either by letting Gitea's installer write the config on first setup or by supplying configuration manually on the host.

## Dependencies

None.

## Example Playbook

The repo already uses this role via [`ansible/playbooks/git.yaml`](../../../playbooks/git.yaml):

```yaml
- hosts: git
  gather_facts: true
  become: true
  roles:
    - role: gitea
```

Minimal example overriding the install paths:

```yaml
- hosts: git
  become: true
  vars:
    gitea_version: "1.21.7"
    gitea_working_directory: /srv/gitea
    gitea_binary: /srv/gitea/bin/gitea
    gitea_env_file: /etc/default/gitea
  roles:
    - role: gitea
```

## Notes

I checked the current official Gitea docs while writing this. The role is broadly aligned with the documented binary-install plus Linux-service approach, but it automates only part of that flow. Inference from comparing the role to the docs: this role was likely built from the older Gitea binary installation guidance, then kept intentionally minimal for this repo's setup rather than trying to encode the entire upstream install procedure.

Official references:

- https://docs.gitea.com/installation/install-from-binary
- https://docs.gitea.com/installation/linux-service

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
