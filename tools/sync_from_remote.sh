#!/bin/sh

# Exit on first error
set -e


# Print help message
help() {
	echo "$(basename "$0") [-h] remote prefix dest

ARGUMENTS:
	source 	host machine where the target can be found
	prefix  prefix (wrt source)where the target directories (\`radarr\`, \`jellyfin\`, etc) can be found
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
if [[ $# -ne 3 ]]; then
	echo "Error: missing source, prefix and/or dest"
	exit 64
fi
source=$1
prefix=$2
dest=$3

# Run rsync
for t in radarr sonarr prowlarr qbittorrent jellyfin; do
	# Ensure the target path doesn't exist in dest
	for t1 in config cache theme; do
		rm -rf $dest/$t1 || true
	done
	rsync -av --exclude="media/*" --exclude="torrent/*" --exclude="torrents/*" $source:$prefix/$t $dest
done

# Wait for all to finish
wait
