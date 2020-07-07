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
CMD [ \
     "/app/prometheus", \
     "--config.file=/config/prometheus.yml", \
     "--storage.tsdb.path=/data", \
     "--storage.tsdb.retention.time=7d", \
     "--web.console.libraries=/config/console_libraries", \
     "--web.console.templates=/config/consoles" \
     ]
```

## Automatic release check with cron
```
# Create two files:
# .telegram_token with your token
# .telegram_chatid with your chat id
# Clone repo and exec hourly cronjob
$ echo "@hourly /home/onkeldom/git-repos/distroless-prometheus/get_release.sh 2>&1 | logger -t build_prometheus" | sudo tee /etc/cron.d/build_prometheus
```
