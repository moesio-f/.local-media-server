#!/bin/sh

# Exit on first error
set -e

# Get target filename
target="$1"
shift

# Go through every filename
for f in "$@"
do
	fname=$(basename -- "$f")
	out="${fname%.*}.$target"
	ffmpeg -i "$f" -map 0 -c:a copy -c:v copy "$out" 
	rm "$f"
done
