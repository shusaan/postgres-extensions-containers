#!/bin/bash
set -e

# Default values..................
PG_VERSION=${PG_VERSION:-18}
PGAUDIT_VERSION=${PGAUDIT_VERSION:-17.0}
DISTRO=${DISTRO:-trixie}
TIMESTAMP=$(date +%Y%m%d%H%M)

# Build image
docker build \
    --build-arg PG_VERSION=${PG_VERSION} \
    --build-arg PGAUDIT_VERSION=${PGAUDIT_VERSION} \
    --build-arg DISTRO=${DISTRO} \
    -t pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${TIMESTAMP}-${DISTRO} \
    -t pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${DISTRO} \
    -t pgaudit:${PG_VERSION%%.*}-${PGAUDIT_VERSION}-${DISTRO} \
    .

echo "Built pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${TIMESTAMP}-${DISTRO}"