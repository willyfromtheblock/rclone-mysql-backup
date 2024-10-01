#!/usr/bin/env bash

set -euo pipefail

# Generate a timestamp
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# shellcheck disable=SC2086
mydumper --host "$MYSQL_HOST" --user $MYSQL_USER --password $MYSQL_PASSWORD --port $MYSQL_PORT --database $MYSQL_DATABASE -C -c -o backup_$TIMESTAMP
rclone config touch
cat <<EOF > ~/.config/rclone/rclone.conf
[remote]
type = s3
provider = Cloudflare
access_key_id = $R2_ACCESS_KEY_ID
secret_access_key = $R2_SECRET_ACCESS_KEY
endpoint = $R2_ENDPOINT
acl = private
EOF
rclone sync backup_$TIMESTAMP remote:"$R2_BUCKET"/"$R2_PATH"/backup_$TIMESTAMP
