#!/usr/bin/env bash

# This script stages an application-level export
# so that Proxmox Backup Server can capture it.
# PBS manages retention and syncs to a second PBS.

set -e

cd /var/backups/mysql-dumps

echo "Creating new backup..."
mysqldump --all-databases | gzip > "dump.sql.gz"
echo "Created backup."

echo "Done."

