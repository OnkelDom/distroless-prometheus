FROM docker.io/ubuntu:20.04 as builder
ARG version=2.19.0

ADD https://github.com/prometheus/prometheus/releases/download/v${version}/prometheus-${version}.linux-amd64.tar.gz /tmp/prometheus-${version}.linux-amd64.tar.gz
RUN mkdir /app /config /data && \
    tar xvzf /tmp/prometheus-${version}.linux-amd64.tar.gz -C /tmp/ && \
    mv /tmp/prometheus-${version}.linux-amd64/prometheus /app/ && \
    mv /tmp/prometheus-${version}.linux-amd64/promtool /app/ && \
    mv /tmp/prometheus-${version}.linux-amd64/tsdb /app/ && \
    mv /tmp/prometheus-${version}.linux-amd64/prometheus.yml /config/ && \
    chmod a+x /app/*

FROM gcr.io/distroless/base-debian10
LABEL maintainer="Dominik Lenhardt <dom@onkeldom.eu>"
COPY --chown=nonroot:nonroot --from=builder /app /app
COPY --chown=nonroot:nonroot --from=builder /config /config
COPY --chown=nonroot:nonroot --from=builder /data /data
WORKDIR /app
CMD ["/app/prometheus","--config.file=/config/prometheus.yml","--storage.tsdb.path=/data","--storage.tsdb.retention.time=7d"]
