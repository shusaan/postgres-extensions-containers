ARG BASE=ghcr.io/cloudnative-pg/postgresql:18-minimal-trixie
FROM $BASE AS builder

ARG PG_MAJOR
ARG EXT_VERSION
ARG DISTRO=trixie

USER 0

RUN set -eux; \
	# Ensure we can fetch the PostgreSQL Apt repository key and add the PGDG repo for the target distro
	apt-get update && \
	apt-get install -y --no-install-recommends gnupg wget ca-certificates dirmngr && \
	wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
	echo "deb http://apt.postgresql.org/pub/repos/apt ${DISTRO}-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
	apt-get update && \
	apt-get install -y --no-install-recommends "postgresql-${PG_MAJOR}-pgaudit=${EXT_VERSION}"

FROM scratch
ARG PG_MAJOR

# Licenses
COPY --from=builder /usr/share/doc/postgresql-${PG_MAJOR}-pgaudit/copyright /licenses/postgresql-${PG_MAJOR}-pgaudit/

# Libraries
COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/vector* /lib/
COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/ /lib/bitcode/

# Share
COPY --from=builder /usr/share/postgresql/${PG_MAJOR}/extension/vector* /share/extension/

USER 65532:65532