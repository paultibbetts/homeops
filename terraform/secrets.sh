export TF_VAR_proxmox_api_url=$(pass pm_api_url)
export TF_VAR_proxmox_api_token_id=$(pass pm_api_token_id)
export TF_VAR_proxmox_api_token_secret=$(pass pm_api_token_secret)

export TF_VAR_pihole_admin_password=$(pass pihole_admin_password)

export TF_VAR_hetzner_api_token=$(pass hetzner_api_token)

export TF_VAR_cloudflare_api_token_public_zone=$(pass cloudflare_api_token_public_zone)

export AWS_ENDPOINT_URL_S3=$(pass minio_endpoint)
export AWS_ACCESS_KEY_ID=$(pass minio_access_key)
export AWS_SECRET_ACCESS_KEY=$(pass minio_secret_key)
