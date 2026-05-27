#!/bin/bash

# Ensure first arg is a directory
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR="$1"

UPPER_DIR=$(mktemp -d --tmpdir ai_upper_XXXXXX)
WORK_DIR=$(mktemp -d --tmpdir ai_work_XXXXXX)
MERGED_DIR=$(mktemp -d --tmpdir ai_merged_XXXXXX)
PLAY_UPPER_DIR=$(mktemp -d --tmpdir ai_play_upper_XXXXXX)
PLAY_WORK_DIR=$(mktemp -d --tmpdir ai_play_work_XXXXXX)
PLAY_MERGED_DIR=$(mktemp -d --tmpdir ai_play_merged_XXXXXX)

echo "Merged dir lives at '$MERGED_DIR'"
echo "Play dir (so taht you don't touch lower dir) lives at '$PLAY_MERGED_DIR'"

sudo mount -t overlay overlay -o lowerdir="$DIR",upperdir="$UPPER_DIR",workdir="$WORK_DIR" "$MERGED_DIR"
sudo mount -t overlay overlay -o lowerdir="$DIR",upperdir="$PLAY_UPPER_DIR",workdir="$PLAY_WORK_DIR" "$PLAY_MERGED_DIR"

docker run --rm -it --mount type=bind,src="$MERGED_DIR",dst="$MERGED_DIR" \
    ainvoke:latest bash -c "cd $MERGED_DIR && copilot update ; claude update ; bash"

echo "Last call to check relevant files at '$MERGED_DIR'"
echo "Press enter to unmount"
read -r
sudo umount "$MERGED_DIR"
sudo umount "$PLAY_MERGED_DIR"

echo "Upper is at '$UPPER_DIR', in case you still want to check it out. You can delete it when done."
echo "Play upper is at '$PLAY_UPPER_DIR', in case you still want to check it out. You can delete it when done."
