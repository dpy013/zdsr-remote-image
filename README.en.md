# ZDSR Remote Server Docker Image

[中文](README.md) | [English](README.en.md)

**Repository links:** [GitHub source repository](https://github.com/dpy013/zdsr-remote-image) · [Docker Hub image repository](https://hub.docker.com/r/star-notes/zdsr-remote) · [GitHub Container Registry](https://github.com/dpy013/zdsr-remote-image/pkgs/container/zdsr-remote)

> This image is built from the official **ZDRemoteServer 2.2.0.0 Linux x64** server distribution.

## Purpose

This image runs the ZDSR screen-reader remote server. It serves both TCP and UDP on the same port, `23188` by default.

## Before you start

- Make sure you are licensed and authorized to use the official ZDSR server files.
- Allow **TCP 23188** and **UDP 23188** in the cloud security group and host firewall.
- Replace the default password with a strong secret. Do not publish the password in `config.json`.
- Mount a persistent directory at `/data`; it stores configuration, logs, and runtime data.

## Docker example

Create a data directory and configuration file:

```bash
mkdir -p zdsr-data
cat > zdsr-data/config.json <<'EOF'
{
  "ServerProtocol": "IPv6",
  "ServerPort": 23188,
  "ServerPassword": "replace-with-a-strong-password",
  "ServerTimeout": 40,
  "LogLevel": "INFO"
}
EOF
```

Run the Docker Hub image with an explicit version tag:

```bash
docker run -d \
  --name zdsr-remote \
  --restart unless-stopped \
  -p 23188:23188/tcp \
  -p 23188:23188/udp \
  -v "$(pwd)/zdsr-data:/data" \
  star-notes/zdsr-remote:2.2.0.2
```

If Docker Hub connectivity is unreliable, use the matching GHCR image instead:

```bash
ghcr.io/dpy013/zdsr-remote:2.2.0.2
```

## Docker Compose example

```yaml
services:
  zdsr-remote:
    image: star-notes/zdsr-remote:2.2.0.2
    container_name: zdsr-remote
    restart: unless-stopped
    ports:
      - "23188:23188/tcp"
      - "23188:23188/udp"
    volumes:
      - ./zdsr-data:/data
```

Start it with:

```bash
docker compose up -d
```

## `config.json` reference

| Field | Description |
|---|---|
| `ServerProtocol` | `IPv6` supports IPv6 and IPv4; `IPv4` listens on IPv4 only. |
| `ServerPort` | Server port; both TCP and UDP use this port. |
| `ServerPassword` | Password required by connecting clients. |
| `ServerTimeout` | Idle disconnect timeout in minutes. |
| `LogLevel` | `ERROR`, `INFO`, or `DEBUG`. |

## Image tag policy

- Use an explicit version tag such as `2.2.0.2` in production; do not use `latest`.
- `latest` points to the newest successful release and is only for testing or users who explicitly accept automatic upgrades.
- Images are published to Docker Hub and GitHub Container Registry with matching tags:

  ```text
  star-notes/zdsr-remote:<version>
  ghcr.io/dpy013/zdsr-remote:<version>
  ```

- Create a Git tag such as `v2.2.1.0` to publish the corresponding version and `latest` automatically. A manual workflow run accepts the version without its `v` prefix.
- `2.2.0.2` is a container packaging revision that includes runtime-loading fixes and dual-registry publishing. The bundled official server program remains `2.2.0.0`.

## Source and redistribution

The official `ZDRemoteServer` and `SQLite.Interop.dll` are included only to build this image. Keep the repository and any derived distribution private unless the upstream license explicitly permits redistribution.