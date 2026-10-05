# 争渡远程服务端 Docker 镜像

[中文](README.md) | [English](README.en.md)

**仓库链接：** [GitHub 源码仓库](https://github.com/dpy013/zdsr-remote-image) · [Docker Hub 镜像仓库](https://hub.docker.com/r/star-notes/zdsr-remote) · [GitHub Container Registry](https://github.com/dpy013/zdsr-remote-image/pkgs/container/zdsr-remote)

> 本镜像基于争渡官方提供的 **ZDRemoteServer 2.2.0.0 Linux x64** 服务端构建。

## 用途

本镜像运行争渡读屏的远程服务端。服务端使用同一个端口提供 TCP 和 UDP 服务，默认端口为 `23188`。

## 使用前须知

- 请确认您拥有使用争渡远程服务端及其官方文件的合法授权。
- 争渡客户端、云服务器安全组和服务器防火墙均须放行 **TCP 23188** 与 **UDP 23188**。
- 请使用强密码替换默认密码；不要公开 `config.json` 中的服务密码。
- 请为 `/data` 挂载持久化目录，否则容器重建后配置、日志和数据可能丢失。

## Docker 运行示例

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

使用 Docker Hub 的固定版本启动：

```bash
docker run -d \
  --name zdsr-remote \
  --restart unless-stopped \
  -p 23188:23188/tcp \
  -p 23188:23188/udp \
  -v "$(pwd)/zdsr-data:/data" \
  star-notes/zdsr-remote:2.2.0.2
```

如 Docker Hub 网络访问不稳定，也可使用 GHCR：

```bash
ghcr.io/dpy013/zdsr-remote:2.2.0.2
```

## Docker Compose 示例

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

运行：

```bash
docker compose up -d
```

## `config.json` 说明

| 配置项 | 说明 |
|---|---|
| `ServerProtocol` | `IPv6` 同时兼容 IPv6 与 IPv4；`IPv4` 仅监听 IPv4。 |
| `ServerPort` | 服务端口，TCP 和 UDP 使用同一端口。 |
| `ServerPassword` | 客户端连接服务器时所用密码。 |
| `ServerTimeout` | 无连接时自动断开的时间，单位为分钟。 |
| `LogLevel` | 日志级别：`ERROR`、`INFO` 或 `DEBUG`。 |

## 镜像标签策略

- 生产环境请使用明确版本标签，例如 `2.2.0.2`；不要使用 `latest`。
- `latest` 指向最新成功发布的版本，只适合测试或明确接受自动升级的用户。
- 镜像会同时发布到 Docker Hub 和 GitHub Container Registry，标签保持一致：

  ```text
  star-notes/zdsr-remote:<版本号>
  ghcr.io/dpy013/zdsr-remote:<版本号>
  ```

- 创建形如 `v2.2.1.0` 的 Git tag 后，工作流会自动发布相应版本和 `latest`；手动运行工作流时填写不带 `v` 的版本号。
- `2.2.0.2` 是包含运行时加载修复及双镜像仓库发布的容器封装修订版；内置的官方服务端程序仍为 `2.2.0.0`。

## 源码与再分发

官方 `ZDRemoteServer` 和 `SQLite.Interop.dll` 仅用于构建本镜像。除非上游许可证明确允许，否则请保持本仓库及任何衍生分发为私有。