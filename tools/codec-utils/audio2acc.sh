#!/bin/sh

# Exit on first error
set -e

# Go through every filename
for f in "$@"
do
	codec=$(mediainfo --Output='Audio;%Format%' "$f")
	if [ "$codec" != "AAC" ]; then
		fname=$(basename -- "$f")
		ext="${fname##*.}"
		out="vid_tmp.$ext"
		ffmpeg -map 0 -i "$f" -acodec aac -vcodec copy "$out"
		mv "$out" "$f"
	else
		echo "'$f' is already AAC."
	fi
done
