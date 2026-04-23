# Kanidm

Deploys the [Kanidm](https://kanidm.com/) identity and access management server as a single Docker Compose application.

The role renders a `server.toml`, writes an `.env` file consumed by Compose, and can generate a self-signed TLS bundle for the service.

## Requirements

- Docker Engine and docker-compose plugin pre-installed on the target host.
- The shared `roles/internal/common/tasks/deploy_compose_app.yaml` task file (invoked internally) to stage assets and manage container lifecycle.
- OpenSSL available on the control node when `kanidm_tls_generate` is true (default).

The role validates `docker compose` availability before attempting any Compose deployment work.

## Role Variables

All variables live under `defaults/main.yaml` unless noted.

| Variable                       | Default                                | Description                                                                                                                                 |
| ------------------------------ | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `kanidm_app_name`              | `kanidm`                               | Logical name passed to the compose deployment tasks.                                                                                        |
| `kanidm_app_path`              | `/srv/www/apps/{{ kanidm_app_name }}`  | Directory where docker-compose assets and persistent data are stored.                                                                       |
| `kanidm_domain`                | `auth.example.com`                     | Public DNS name for the service, used in config and TLS subject.                                                                            |
| `kanidm_origin`                | `https://{{ kanidm_domain }}`          | External origin URL advertised to clients.                                                                                                  |
| `kanidm_https_port`            | `8443`                                 | Host port mapped to the container's HTTPS listener (443).                                                                                   |
| `kanidm_ldap_port`             | `8636`                                 | Host port mapped to the container's LDAP over TLS listener (636).                                                                           |
| `kanidm_image`                 | pinned `kanidm/server` image           | Container image reference written to the Compose `.env` file. Override to test newer releases intentionally.                                |
| `kanidm_tls_chain_path`        | `{{ kanidm_app_path }}/data/chain.pem` | Path where the TLS certificate chain is expected.                                                                                           |
| `kanidm_tls_key_path`          | `{{ kanidm_app_path }}/data/key.pem`   | Path to the TLS private key.                                                                                                                |
| `kanidm_tls_generate`          | `true`                                 | When true the role calls `openssl` to mint a self-signed certificate if one does not already exist. Set to false to supply your own assets. |
| `kanidm_tls_validity_days`     | `365`                                  | Number of days the generated certificate remains valid.                                                                                     |
| `kanidm_tls_subject_alt_names` | `[ "DNS:{{ kanidm_domain }}" ]`        | Additional SAN entries appended when generating certificates.                                                                               |
| `apps_path` (vars)             | `/srv/www/apps`                        | Shared base path consumed by the compose deployment tasks; override if you use a different root.                                    |

This role does not bootstrap Kanidm admin credentials. Use Kanidm's documented account recovery flow to initialize or recover the built-in `admin` and `idm_admin` accounts after deployment.

## Dependencies

The role includes the shared compose deployment tasks internally, but it does not install Docker itself. Ensure Docker and the Compose plugin are installed before applying the role.

## Example Playbook

```yaml
- name: Deploy Kanidm
  hosts: iam_servers
  become: true
  vars:
    kanidm_domain: auth.internal.example.com
    kanidm_tls_generate: false
  roles:
    - role: geerlingguy.docker
    - role: kanidm
```

This example demonstrates overriding the domain and opting out of certificate generation (to supply a trusted cert bundle).

## Check Mode

When run with `--check`, the role only reports a reminder and skips directory creation, TLS generation, templating, and Compose deployment. Plan to run it without check mode to perform actual changes.

## License

MIT

## Author Information

[Paul Tibbetts](https://paultibbetts.uk)
