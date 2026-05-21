# act_runner

Installs Gitea `act_runner` from the upstream binary release and manages it as
a systemd service. This role expects Docker to be installed before it runs; in
this repo the `git.yaml` playbook applies `geerlingguy.docker` first.

The runner is configured to execute jobs in Docker containers. It also enables
the runner cache server by default and advertises it using
`act_runner_cache_host`, which should be reachable from Docker job containers.

## Required Variables

| Variable | Purpose |
| --- | --- |
| `act_runner_instance_url` | Base URL for the Gitea instance. |
| `act_runner_registration_token` | Initial registration token from Gitea. Required only until `{{ act_runner_runner_file }}` exists. Store this in Ansible Vault. |

## Useful Defaults

| Variable | Default |
| --- | --- |
| `act_runner_version` | `0.2.11` |
| `act_runner_user` | `act_runner` |
| `act_runner_config_path` | `/etc/act_runner/config.yaml` |
| `act_runner_working_directory` | `/var/lib/act_runner` |
| `act_runner_cache_enabled` | `true` |
| `act_runner_cache_host` | `{{ inventory_hostname }}` |
| `act_runner_cache_port` | `8088` |

Example group vars for this repo:

```yaml
act_runner_instance_url: "https://gitea.cloud.paultibbetts.uk"
act_runner_name: "gitea-runner"
act_runner_cache_host: "gitea-runner.infra.home.arpa"
act_runner_registration_token: "{{ vault_act_runner_registration_token }}"
```

The role does not create the registration token in Gitea. Generate it in the
Gitea UI, add it to Vault, run the playbook once, then rotate or discard the
token if you do not want it to remain valid.
