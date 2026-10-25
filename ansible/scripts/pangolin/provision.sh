#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR/../../"

if [[ -z "${MAKELEVEL:-}" ]]; then
  echo "ERROR: Do not run this script directly. Use 'make tunnel'." >&2
  exit 1
fi

pause() {
  echo ""
  echo "ACTION REQUIRED:"
  echo $1
  read -r -p "Press Enter to continue..." _
}

beszel_machine_client_enabled() {
  grep -Eq '^[[:space:]]*pangolin_beszel_machine_client_enabled:[[:space:]]*true[[:space:]]*$' \
    "$ANSIBLE_DIR/group_vars/tunnel/main.yaml"
}

configure_pangolin_beszel() {
  local initial_setup="${1:-false}"

  # Reconcile the private resource before asking for a client that needs it.
  uv run ansible-playbook playbooks/tunnel.yaml --limit 'tunnel:&site_home' --tags newt

  if [[ "$initial_setup" == "true" ]] || ! beszel_machine_client_enabled; then
    pause "In Pangolin, create a machine client named 'pangolin-edge-beszel'. Leave its Roles empty. Then open Resources > Private > Beszel Hub and, in Access, add that machine client directly. Store its ID and secret as 'vault_pangolin_beszel_machine_client_id' and 'vault_pangolin_beszel_machine_client_secret' with 'ansible-vault edit group_vars/tunnel/vault.yaml', then set 'pangolin_beszel_machine_client_enabled: true' in 'group_vars/tunnel/main.yaml'."
  fi

  if ! beszel_machine_client_enabled; then
    echo "ERROR: Pangolin Beszel machine-client setup is still disabled." >&2
    echo "Add the Vault credentials and set pangolin_beszel_machine_client_enabled: true, then rerun 'make tunnel' and select initial setup." >&2
    exit 1
  fi

  # The private client must be connected before the edge Beszel agent starts.
  uv run ansible-playbook playbooks/tunnel.yaml --limit pangolin.hcloud \
    --tags pangolin_beszel_machine_client
  uv run ansible-playbook playbooks/beszel.yaml --limit pangolin.hcloud \
    --tags pangolin_beszel_edge
}

echo ""
read -r -p "Is this the initial setup? [y/N] " response

case "$response" in
  [yY]|[yY][eE][sS])
    # 0) Warn about 'pangolin_crowdsec_lapi_key'
    pause "Ensure you have not set 'pangolin_crowdsec_lapi_key' in 'group_vars/tunnel/vault.yaml'"

    # 1) Load secrets required for the Terraform-based Ansible inventory to work
    source "$ANSIBLE_DIR/../terraform/secrets.sh"

    # 2) Install Pangolin
    # The machine client cannot exist until Pangolin, Newt, and its private
    # resource have been created later in this initial-setup flow.
    uv run ansible-playbook site.yaml --limit tunnel --tags pangolin \
      --extra-vars "pangolin_beszel_machine_client_enabled=false"

    # 3) Manual Pangolin steps

    pause "SSH in, 'cd /srv/pangolin && docker compose logs pangolin -f'"

    pause "Capture the token it generates to use for '/auth/initial-setup'"

    pause "Run 'docker exec -it crowdsec cscli bouncers add traefik-bouncer' and capture the key it generates"

    pause "Visit the Pangolin UI and create the admin user, the org, and a site called 'Home' with an ID of 'home'"

    pause "Create a MaxMind key at 'https://www.maxmind.com/en/accounts/<id>/license-key'"

    pause "Store credentials using 'ansible-vault edit group_vars/tunnel/vault.yaml'"

    # 4) Install Newt with auth blueprint
    uv run ansible-playbook playbooks/tunnel.yaml --tags newt \
      --extra-vars "newt_blueprint_mode=auth-only"

    # 5) Register IDP for Pangolin SSO
    pause "Visit Pangolin and register the IDP. Set the default mappings. The IDP ID should be 1."

    # 6) Run Newt with full blueprint using the IDP ID
    uv run ansible-playbook playbooks/tunnel.yaml --tags newt

    # 7) Configure private Beszel monitoring of the Pangolin edge.
    # This is a required part of a new tunnel installation. The helper pauses
    # only until the machine-client credentials have been created and vaulted.
    configure_pangolin_beszel true
    ;;
  *)
    source "$ANSIBLE_DIR/../terraform/secrets.sh"
    uv run ansible-playbook playbooks/tunnel.yaml
    uv run ansible-playbook playbooks/beszel.yaml \
      --limit 'tunnel:&site_edge' \
      --tags pangolin_beszel_edge
    ;;
esac

echo "Done."
