#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ansible_dir="$(cd "${script_dir}/../.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  decrypt-value.sh [--debug] --file vars_file <var_name> [nested_key]

Examples:
  decrypt-value.sh --file group_vars/all/vault.yaml vault_internal_dns_zone
  decrypt-value.sh --debug --file group_vars/apps/renovate.yaml renovate_dockerhub_username
  decrypt-value.sh --file group_vars/ingress/main.yaml ingress_services auth

Output modes:
  default  Just the resolved value as plain text
  --debug  Ansible's normal human-readable output
EOF
}

debug_mode=false
vars_file=""

if [[ "${1:-}" == "--debug" ]]; then
  debug_mode=true
  shift
fi

if [[ "${1:-}" == "--file" ]]; then
  if [[ $# -lt 2 ]]; then
    usage
    exit 1
  fi
  vars_file="$2"
  shift 2
fi

if [[ -z "$vars_file" || $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

var_name="$1"
sub_key=""

if [[ $# -eq 2 ]]; then
  sub_key="$2"
fi

tmp_playbook="$(mktemp)"
cleanup() {
  rm -f "$tmp_playbook"
}
trap cleanup EXIT

cat >"$tmp_playbook" <<'EOF'
---
- hosts: localhost
  gather_facts: false
  connection: local
  tasks:
    - name: Show resolved value
      ansible.builtin.debug:
        msg: >-
          {{
            lookup('vars', target_var_name)[target_sub_key]
            if (target_sub_key | length > 0)
            else lookup('vars', target_var_name)
          }}
EOF

cd "$ansible_dir"

ansible_cmd=(
  ansible-playbook
  -i localhost,
  "$tmp_playbook"
  -e "@${vars_file}"
  -e "target_var_name=${var_name}"
  -e "target_sub_key=${sub_key}"
)

if [[ "$debug_mode" == true ]]; then
  exec "${ansible_cmd[@]}"
fi

ANSIBLE_STDOUT_CALLBACK=json ANSIBLE_DEPRECATION_WARNINGS=False \
  "${ansible_cmd[@]}" \
  | jq -r '.plays[0].tasks[0].hosts.localhost.msg'
