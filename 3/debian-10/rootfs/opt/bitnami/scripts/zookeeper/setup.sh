#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
if [[ "${BITNAMI_DEBUG:-false}" != "false" ]]; then
    set -o xtrace
fi

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libzookeeper.sh

# Load ZooKeeper environment variables
eval "$(zookeeper_env)"

# Ensure ZooKeeper environment variables are valid
zookeeper_validate
# Ensure ZooKeeper user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$ZOO_DAEMON_USER" "$ZOO_DAEMON_GROUP"
    ZOOKEEPER_OWNERSHIP_USER="$ZOO_DAEMON_USER"
else
    ZOOKEEPER_OWNERSHIP_USER=""
fi
# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir" "$ZOOKEEPER_OWNERSHIP_USER"
done
# Ensure ZooKeeper is initialized
zookeeper_initialize
