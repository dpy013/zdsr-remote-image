# ZDSR Remote Server image

This repository builds a Docker image from the official **ZDRemoteServer 2.2.0.0 Linux x64** distribution.

> Keep this repository **private** unless the upstream license explicitly permits redistribution of the official server files and resulting image.

## Add the official runtime files

From `争渡远程服务端程序_2.2.0.0.zip`, extract:

1. `ZDRemoteServer260909/ZDRemoteServer_linux-x64/ZDRemoteServer`
2. `ZDRemoteServer260909/ZDRemoteServer_linux-x64/SQLite.Interop.dll`

Place both files in this repository root next to `Dockerfile`.

## GitHub secrets

In the GitHub repository, open **Settings → Secrets and variables → Actions** and add:

| Secret | Value |
|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | A Docker Hub Read & Write personal access token |

## Publish

Create and push a version tag to trigger a build:

```bash
git tag v2.2.0.0
git push origin v2.2.0.0
```

Or run **Actions → Build and publish image → Run workflow** manually.

The workflow publishes:

```text
<DOCKERHUB_USERNAME>/zdsr-remote:2.2.0.0
<DOCKERHUB_USERNAME>/zdsr-remote:latest
```

## Server deployment

The server reads and writes `config.json` in its current working directory. Mount a persistent host directory at `/data`, and publish both TCP and UDP port `23188`.