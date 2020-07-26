FROM docker.io/ubuntu:20.04 as builder
ARG version=2.19.3

ADD https://github.com/prometheus/prometheus/releases/download/v${version}/prometheus-${version}.linux-amd64.tar.gz /tmp/prometheus-${version}.linux-amd64.tar.gz
RUN mkdir /app /config /data && \
    tar xvzf /tmp/prometheus-${version}.linux-amd64.tar.gz -C /tmp/ && \
    mv /tmp/prometheus-${version}.linux-amd64/prometheus /app/ && \
    mv /tmp/prometheus-${version}.linux-amd64/promtool /app/ && \
    mv /tmp/prometheus-${version}.linux-amd64/tsdb /app/ && \
    mv /tmp/prometheus-${version}.linux-amd64/prometheus.yml /config/ && \
    mv /tmp/prometheus-${version}.linux-amd64/console_libraries/ /config/ && \
    mv /tmp/prometheus-${version}.linux-amd64/consoles/ /config/ && \
    chmod a+x /app/*

# Basic distroless debian10 image
FROM gcr.io/distroless/base-debian10

# Maintaincer label
LABEL maintainer="Dominik Lenhardt <dom@onkeldom.eu>"

# Copy from builder
COPY --chown=nonroot:nonroot --from=builder /app /app
COPY --chown=nonroot:nonroot --from=builder /config /config
COPY --chown=nonroot:nonroot --from=builder /data /data

# Application defaults
WORKDIR /data
VOLUME ["/data"]
EXPOSE 9090

# Application default cmd
CMD [ \
     "/app/prometheus", \
     "--config.file=/config/prometheus.yml", \
     "--storage.tsdb.path=/data", \
     "--storage.tsdb.retention.time=7d", \
     "--web.console.libraries=/config/console_libraries", \
     "--web.console.templates=/config/consoles" \
     ]
