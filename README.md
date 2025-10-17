# aria2 rpc + Web UI (Ubuntu 22.04)
Lightweight Ubuntu 22.04 image with aria2c (RPC enabled) and bundled webui-aria2 assets. It creates `/downloads`, `/config`, and `/webui-aria2`, exposes RPC on 6800 and a web UI port on 80, and starts aria2 using /config/aria2.conf. The web UI files are included under /webui-aria2.

- Base: `ubuntu:22.04`; installs `python3.10` and `aria2`
- Args: `LISTEN_PORT=6800`, `WEBUI_PORT=80`, `DOWNLOAD_DIR=/downloads`, `CONFIG_DIR=/config`
- Exposed ports: `6800` (RPC), `80` (optional web UI)
- Volumes: mount `/downloads` for data and `/config` for `aria2.conf`

# Quick start:

## Using `docker run`:

```bash
docker run -d --name aria2-rpc \
  --log-driver json-file --log-opt max-size=1m \
  -p 6800:6800 \
  -v "/path/to/downloads:/downloads" \
  -v "/path/to/config:/config" \
  aminelazz/aria2 \
  aria2c --conf-path=/config/aria2.conf
```

```bash
docker run -d --name aria2-webui \
  -p 8080:80 \
  --volumes-from aria2-rpc \
  aminelazz/aria2 \
  python3.10 -m http.server -d /webui-aria2/docs 80
```

## Using `docker-compose.yaml`:

### File:

```yaml
services:
  aria2-rpc:
    image: aria2
    container_name: aria2-rpc
    network_mode: bridge
    ports:
      - ${LISTEN_PORT}:6800
    volumes:
      - ${ARIA2_CONFIG_DIR}:/config
      - ${ARIA2_DOWNLOAD_DIR}:/downloads
    # Since Aria2 will continue to generate logs, limit the log size to 1M to prevent your hard disk from running out of space.
    logging:
      driver: json-file
      options:
        max-size: 1m
    command: aria2c --conf-path=/config/aria2.conf

  aria2-webui:
    image: aria2
    container_name: aria2-webui
    # restart: unless-stopped
    # network_mode: host
    network_mode: bridge
    ports:
      - ${WEBUI_PORT}:80
    depends_on:
      - aria2-rpc
    command: python3.10 -m http.server -d /webui-aria2/docs 80
```

### `.env` file:

```env
ARIA2_CONFIG_DIR=./src/config
ARIA2_DOWNLOAD_DIR=./src/downloads
LISTEN_PORT=6800
WEBUI_PORT=4500
```

### `aria2.conf` file:

```conf
enable-rpc=true
rpc-listen-all
seed-time=0
follow-torrent=mem
allow-overwrite=true
rpc-secret=YOUR_RPC_SECRET
max-download-limit=1024M
disable-ipv6=true
```