# Local Media Server

This repository contains a simple template for a personal media server with streaming support.

## Setup and Run

- Initialize applications with `docker compose up -d`;
- Configure system-wide mounts for `media` and `torrent` directories;
    - `config`, `cache` and `theme` directories are automatically managed by each application;
- Allow network traffic for each application;
    - Jellyfin: `8096/HTTP`, `8920/HTTPS`
    - Radarr: `7878/HTTP`
    - Sonarr: `8989/HTTP`
    - Prowlar: `9696/HTTP`
    - qBittorrent: `3344/HTTP`
- Access each application web-interfaces and configure them accordingly;
