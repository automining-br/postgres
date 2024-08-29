# add extensions to cnpg postgresql image: timescaledb, pg_cron
ARG POSTGRESQL_VERSION=16.0
ARG EXTENSIONS="cron"

FROM ghcr.io/cloudnative-pg/postgis:${POSTGRESQL_VERSION}
ARG EXTENSIONS
ENV EXTENSIONS=${EXTENSIONS}

COPY ./install_pg_extensions.sh /
# switch to root user to install extensions
USER root
RUN \
  apt-get update && \
  /install_pg_extensions.sh ${EXTENSIONS} && \
  # cleanup
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /install_pg_extensions.sh
# switch back to the postgres user
USER postgres
