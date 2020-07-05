# distroless-prometheus

Automatic build for distroless prometheus container

## Volumes

```
/app = application folder with /app/<command>
/config = config folder with /config/<app>.ext
/data = data forlder with /data volume mount
```

## Default CMD
```
CMD ["/app/prometheus","--config.file=/config/prometheus.yml","--storage.tsdb.path=/data","--storage.tsdb.retention.time=7d"]
```
