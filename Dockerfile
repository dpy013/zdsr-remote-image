FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-focal

WORKDIR /data
COPY ZDRemoteServer SQLite.Interop.dll /app/
RUN useradd --uid 1000 --gid 100 --no-create-home --shell /usr/sbin/nologin remote

USER 1000:100
EXPOSE 23188/tcp 23188/udp
ENTRYPOINT ["/app/ZDRemoteServer"]