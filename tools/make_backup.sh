#!/bin/sh
# Exit on first error
set -e

# Create backup with tar
tar -czf backup.tar.gz sonarr radarr prowlarr qbittorrent jellyfin
