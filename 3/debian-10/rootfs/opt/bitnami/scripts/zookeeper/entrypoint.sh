#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
if [[ "${BITNAMI_TRACE:-false}" != "false" ]]; then
    set -o xtrace
fi

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libzookeeper.sh

# Load ZooKeeper environment variables
eval "$(zookeeper_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/zookeeper/run.sh" || "$*" = "/run.sh" ]]; then
    info "** Starting ZooKeeper setup **"
    /opt/bitnami/scripts/zookeeper/setup.sh
    info "** ZooKeeper setup finished! **"
fi

echo ""
exec "$@"
