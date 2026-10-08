FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-jammy

ARG IMAGE_VERSION=2.2.0.3
LABEL org.opencontainers.image.title="ZDSR Remote Server" \
      org.opencontainers.image.description="Container image for the official ZDRemoteServer Linux x64 binary" \
      org.opencontainers.image.source="https://github.com/dpy013/zdsr-remote-image" \
      org.opencontainers.image.version="${IMAGE_VERSION}"

ENV LD_LIBRARY_PATH=/app

WORKDIR /data
COPY --chown=1000:100 ZDRemoteServer SQLite.Interop.dll /app/
RUN chmod 0755 /app/ZDRemoteServer && \
    chmod 0644 /app/SQLite.Interop.dll && \
    ln -s /app/SQLite.Interop.dll /app/libSQLite.Interop.dll.so && \
    ln -s /app/SQLite.Interop.dll /app/SQLite.Interop.dll.so && \
    useradd --uid 1000 --gid 100 --no-create-home --shell /usr/sbin/nologin remote

USER 1000:100
EXPOSE 23188/tcp 23188/udp
ENTRYPOINT ["/app/ZDRemoteServer"]