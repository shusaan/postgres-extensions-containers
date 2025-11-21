ARG PG_VERSION=18
ARG DISTRO=bookworm
FROM ghcr.io/cloudnative-pg/postgresql:${PG_VERSION}-minimal-${DISTRO} AS builder

ARG PG_VERSION
ARG DISTRO

USER 0

COPY . /tmp/pgaudit

RUN set -eux; \
	mkdir -p /opt/extension && \
	apt-get update && \
	apt-get install -y --no-install-recommends build-essential git "postgresql-server-dev-${PG_VERSION}=${PG_VERSION}*" libkrb5-dev libxml2-dev && \
	cd /tmp/pgaudit && \
	# If the build context contains a git repository, try to check out the release branch.
	# When the build context does NOT include .git (typical for CI buildx), skip checkout
	# and build from the provided sources.
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
		git checkout REL_18_STABLE || true; \
	fi && \
	PG_CONFIG=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config USE_PGXS=1 make clean && \
	PG_CONFIG=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config USE_PGXS=1 OPTFLAGS="" make && \
	PG_CONFIG=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config USE_PGXS=1 make install datadir=/opt/extension/share/ pkglibdir=/opt/extension/lib/

FROM scratch

COPY --from=builder /opt/extension/lib/ /lib/
COPY --from=builder /opt/extension/share/ /share/