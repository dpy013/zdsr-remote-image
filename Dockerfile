FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-focal

LABEL org.opencontainers.image.title="ZDSR Remote Server" \
      org.opencontainers.image.description="Container image for the official ZDRemoteServer Linux x64 binary" \
      org.opencontainers.image.source="https://github.com/dpy013/zdsr-remote-image" \
      org.opencontainers.image.version="2.2.0.0"

WORKDIR /data
COPY ZDRemoteServer SQLite.Interop.dll /app/
RUN useradd --uid 1000 --gid 100 --no-create-home --shell /usr/sbin/nologin remote

USER 1000:100
EXPOSE 23188/tcp 23188/udp
ENTRYPOINT ["/app/ZDRemoteServer"]