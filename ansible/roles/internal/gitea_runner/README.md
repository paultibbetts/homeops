# Gitea Runner

Installs Gitea `gitea-runner` from the upstream binary release and manages it
as a systemd service. This role expects Docker to be installed before it runs;
in this repo the `git.yaml` playbook applies `geerlingguy.docker` first.

The runner is configured to execute jobs in Docker containers. It also enables
the runner cache server by default and advertises it using
`gitea_runner_cache_host`, which should be reachable from Docker job containers.

## Required Variables

| Variable | Purpose |
| --- | --- |
| `gitea_runner_instance_url` | Base URL for the Gitea instance. |
| `gitea_runner_registration_token` | Initial registration token from Gitea. Required only until `{{ gitea_runner_runner_file }}` exists. Store this in Ansible Vault. |

## Useful Defaults

| Variable | Default |
| --- | --- |
| `gitea_runner_version` | `1.0.5` |
| `gitea_runner_user` | `gitea-runner` |
| `gitea_runner_config_path` | `/etc/gitea-runner/config.yaml` |
| `gitea_runner_working_directory` | `/var/lib/gitea-runner` |
| `gitea_runner_cache_enabled` | `true` |
| `gitea_runner_cache_host` | `{{ inventory_hostname }}` |
| `gitea_runner_cache_port` | `8088` |

Example group vars for this repo:

```yaml
gitea_runner_instance_url: "https://gitea.cloud.paultibbetts.uk"
gitea_runner_name: "gitea-runner"
gitea_runner_cache_host: "gitea-runner.infra.home.arpa"
gitea_runner_registration_token: "{{ vault_gitea_runner_registration_token }}"
```

The role does not create the registration token in Gitea. Generate it in the
Gitea UI, add it to Vault, run the playbook once, then rotate or discard the
token if you do not want it to remain valid.
