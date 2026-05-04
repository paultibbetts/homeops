#!/usr/bin/env bash

# This script stages an application-level export
# so that Proxmox Backup Server can capture it.
# PBS manages retention and syncs to a second PBS.

set -e

cd /var/backups/postgres-dumps

echo "Creating new backup..."
sudo -u postgres pg_dumpall > dump.sql
echo "Created backup."

echo "Compressing..."
gzip -f dump.sql
echo "Compressed."

echo "Done."

