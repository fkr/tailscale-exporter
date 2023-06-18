# syntax=docker/dockerfile:1
FROM golang:1.18-alpine
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN go build -o /tailscale-exporter

# second stage for running
FROM prom/busybox:glibc
COPY --from=0 /tailscale-exporter /usr/local/bin/tailscale-exporter
EXPOSE 8080
ENTRYPOINT [ "/usr/local/bin/tailscale-exporter" ]
