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
	apt-get install -y --no-install-recommends build-essential git curl "postgresql-server-dev-${PG_VERSION}=${PG_VERSION}*" libkrb5-dev libxml2-dev && \
	cd /tmp/pgaudit && \
	# If the build context contains a git repository, try to check out the release branch.
	# When the build context does NOT include .git (typical for CI buildx), skip checkout
	# and try to fetch the upstream release tarball to ensure Makefile and build files exist.
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
		git checkout REL_18_STABLE || true; \
	fi; \
	# If there's no Makefile in the provided context, fetch the upstream sources for REL_18_STABLE
	# and merge them into the build directory so make will work.
	if [ ! -f ./Makefile ]; then \
		echo "Makefile not found in context; fetching upstream release sources"; \
		UPSTREAM_REPO="https://github.com/pgaudit/pgaudit"; \
		UPSTREAM_TARBALL="$UPSTREAM_REPO/archive/refs/heads/REL_18_STABLE.tar.gz"; \
		mkdir -p /tmp/pgaudit-upstream; \
		curl -sSL "$UPSTREAM_TARBALL" | tar xz -C /tmp/pgaudit-upstream --strip-components=1; \
		# Copy missing files from upstream into the build context (don't overwrite local files)
		shopt -s dotglob || true; \
		for f in /tmp/pgaudit-upstream/*; do \
			name=$(basename "$f"); \
			if [ ! -e "/tmp/pgaudit/$name" ]; then \
				cp -a "$f" "/tmp/pgaudit/"; \
			fi; \
		done; \
	fi && \
	PG_CONFIG=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config USE_PGXS=1 make clean || true && \
	PG_CONFIG=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config USE_PGXS=1 OPTFLAGS="" make && \
	PG_CONFIG=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config USE_PGXS=1 make install datadir=/opt/extension/share/ pkglibdir=/opt/extension/lib/

FROM scratch

COPY --from=builder /opt/extension/lib/ /lib/
COPY --from=builder /opt/extension/share/ /share/