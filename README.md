# 争渡远程服务端 Docker 镜像 / ZDSR Remote Server Docker Image

[中文](#中文说明) · [English](#english)

> 本镜像基于争渡官方提供的 **ZDRemoteServer 2.2.0.0 Linux x64** 服务端构建。
>
> This image is built from the official **ZDRemoteServer 2.2.0.0 Linux x64** server distribution.

## 中文说明

### 用途

本镜像运行争渡读屏的远程服务端。服务端使用同一个端口提供 TCP 和 UDP 服务，默认端口为 `23188`。

### 使用前须知

- 请确认您拥有使用争渡远程服务端及其官方文件的合法授权。
- 争渡客户端、云服务器安全组和服务器防火墙均须放行 **TCP 23188** 与 **UDP 23188**。
- 请使用强密码替换默认密码；不要公开 `config.json` 中的服务密码。
- 请为 `/data` 挂载持久化目录，否则容器重建后配置、日志和数据可能丢失。

### Docker 运行示例

创建数据目录和配置文件：

```bash
mkdir -p zdsr-data
cat > zdsr-data/config.json <<'EOF'
{
  "ServerProtocol": "IPv6",
  "ServerPort": 23188,
  "ServerPassword": "请替换为高强度密码",
  "ServerTimeout": 40,
  "LogLevel": "INFO"
}
EOF
```

启动服务。将 `<DockerHub用户名>` 替换为实际 Docker Hub 用户名：

```bash
docker run -d \
  --name zdsr-remote \
  --restart unless-stopped \
  -p 23188:23188/tcp \
  -p 23188:23188/udp \
  -v "$(pwd)/zdsr-data:/data" \
  <DockerHub用户名>/zdsr-remote:latest
```

### Docker Compose 示例

```yaml
services:
  zdsr-remote:
    image: <DockerHub用户名>/zdsr-remote:latest
    container_name: zdsr-remote
    restart: unless-stopped
    ports:
      - "23188:23188/tcp"
      - "23188:23188/udp"
    volumes:
      - ./zdsr-data:/data
```

运行：

```bash
docker compose up -d
```

### `config.json` 说明

```json
{
  "ServerProtocol": "IPv6",
  "ServerPort": 23188,
  "ServerPassword": "高强度服务密码",
  "ServerTimeout": 40,
  "LogLevel": "INFO"
}
```

| 配置项 | 说明 |
|---|---|
| `ServerProtocol` | `IPv6` 同时兼容 IPv6 与 IPv4；`IPv4` 仅监听 IPv4。 |
| `ServerPort` | 服务端口，TCP 和 UDP 使用同一端口。 |
| `ServerPassword` | 客户端连接服务器时所用密码。 |
| `ServerTimeout` | 无连接时自动断开的时间，单位为分钟。 |
| `LogLevel` | 日志级别：`ERROR`、`INFO` 或 `DEBUG`。 |

### 更新

```bash
docker pull <DockerHub用户名>/zdsr-remote:latest
docker compose up -d
```

---

## English

### Purpose

This image runs the ZDSR screen-reader remote server. It serves both TCP and UDP on the same port, `23188` by default.

### Before you start

- Make sure that you are licensed and authorized to use the official ZDSR server files.
- Allow **TCP 23188** and **UDP 23188** in the cloud security group and host firewall.
- Replace the default password with a strong secret. Do not publish the `config.json` password.
- Mount a persistent directory at `/data`; it stores configuration, logs, and runtime data.

### Docker example

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

Run the container. Replace `<DockerHubUsername>` with the actual Docker Hub username:

```bash
docker run -d \
  --name zdsr-remote \
  --restart unless-stopped \
  -p 23188:23188/tcp \
  -p 23188:23188/udp \
  -v "$(pwd)/zdsr-data:/data" \
  <DockerHubUsername>/zdsr-remote:latest
```

### Docker Compose example

```yaml
services:
  zdsr-remote:
    image: <DockerHubUsername>/zdsr-remote:latest
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

### `config.json` reference

| Field | Description |
|---|---|
| `ServerProtocol` | `IPv6` supports IPv6 and IPv4; `IPv4` listens on IPv4 only. |
| `ServerPort` | Server port; both TCP and UDP use this port. |
| `ServerPassword` | Password required by connecting clients. |
| `ServerTimeout` | Idle disconnect timeout in minutes. |
| `LogLevel` | `ERROR`, `INFO`, or `DEBUG`. |

### Update

```bash
docker pull <DockerHubUsername>/zdsr-remote:latest
docker compose up -d
```

## Source and redistribution

The official ZDRemoteServer binary and `SQLite.Interop.dll` are included only to build this image. Keep the repository and any derived distribution private unless the upstream license explicitly permits redistribution.

## Image tag policy / 镜像标签策略

- Production deployments should use an explicit version tag, such as `star-notes/zdsr-remote:2.2.0.0`. Do not use `latest` in production.
- `latest` always points to the newest successful release and is provided only for testing or users who explicitly accept automatic upgrades.
- Create a Git tag in the form `v2.2.1.0` to publish Docker tags `2.2.1.0` and `latest` automatically. A manual workflow run accepts the same version number without the `v` prefix.

- 生产环境应使用明确版本标签，例如 `star-notes/zdsr-remote:2.2.0.0`；不要在生产环境使用 `latest`。
- `latest` 始终指向最新成功发布的版本，只适合测试或明确接受自动升级的用户。
- 创建形如 `v2.2.1.0` 的 Git tag 后，工作流会自动发布 `2.2.1.0` 与 `latest` 两个 Docker 标签；手动运行工作流时填写不带 `v` 的同一版本号。

- Image version `2.2.0.1` is a container packaging revision that includes runtime-loading fixes; the bundled official server program remains `2.2.0.0`.
- 镜像版本 `2.2.0.1` 是包含运行时加载修复的容器封装修订版；内置的官方服务端程序仍为 `2.2.0.0`。
