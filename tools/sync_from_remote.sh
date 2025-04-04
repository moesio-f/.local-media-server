#!/bin/sh

# Exit on first error
set -e


# Print help message
help() {
	echo "$(basename "$0") [-h] source dest

ARGUMENTS:
	source 	root path where the target directories (\`radarr\`, \`jellyfin\`, etc) can be found
	dest	destionation path to sync (follows the same structure as the repository)

OPTIONS:
	-h  show this help text"
}

# Parse arguments and args

while getopts ":h" option; do
   case $option in
      h) # display Help
         help
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
	 help
         exit;;
   esac
done

# Obtain source and dest
if [[ $# -ne 2 ]]; then
	echo "Error: missing source and/or dest"
	exit 64
fi
source=$1
dest=$2

# Run rsync
for t in radarr sonarr prowlarr qbittorrent jellyfin; do
	rsync -av $source:$t $dest
done

# Wait for all to finish
wait
