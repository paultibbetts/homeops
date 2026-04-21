#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  cat <<'EOF'
Usage:
  encrypt-value.sh <yaml_key> <value>

Examples:
  encrypt-value.sh internal_dns_zone home.arpa

This prints an inline !vault YAML fragment ready to paste into a vars file.
For nested mappings, pass the leaf key name and paste the result under the
parent mapping with the correct indentation.
EOF
  exit 1
fi

key="$1"
shift
value="$*"

exec ansible-vault encrypt_string --name "$key" "$value"
