#!/bin/sh

# Exit on first error
set -e

# Go through every filename
for f in "$@"
do
	fname=$(basename -- "$f")
	ext="${fname##*.}"
	out="vid_tmp.$ext"
	ffmpeg -i "$f" -map 0 -c:a copy -c:v libx264 -crf 18 -vf format=yuv420p "$out" 
	mv "$out" "$f"
done
