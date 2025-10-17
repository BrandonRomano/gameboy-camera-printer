#!/usr/bin/env bash
# Depends on imagesnap, which can be installed via `brew install imagesnap`
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/../input"
PROCESSED_DIR="$SCRIPT_DIR/../processed"

next_filename() {
  # Find the highest numbered image in processed directory
  local last_img=$(ls "$PROCESSED_DIR"/img_*.jpg 2>/dev/null | sort -V | tail -n 1)

  if [ -z "$last_img" ]; then
    # No images exist, start with 00001
    echo "img_00001.jpg"
  else
    # Extract the number from the filename (e.g., img_00005.jpg -> 00005)
    local last_num=$(basename "$last_img" | sed 's/img_\([0-9]*\)\.jpg/\1/')
    # Remove leading zeros and increment
    local next_num=$((10#$last_num + 1))
    # Format with 5 digits, zero-padded
    printf "img_%05d.jpg" "$next_num"
  fi
}

take_picture() {
  imagesnap -d "$GBCP_VIDEO_DEVICE_NAME" "$INPUT_DIR/$(next_filename)" > /dev/null
}

#
# imagesnap takes a brief moment to actually take the picture, so I'm adding in
# an artificial timer here to just indicate how long it takes to take a picture.
#
countdown() {
  local total=${GBCP_VIDEO_DEVICE_DELAY_HALFSECONDS:-6}
  for ((i=total; i>=0; i--)); do
    local progress=$((total - i))
    local filled=$((progress * 20 / total))
    local empty=$((20 - filled))

    # Build progress bar
    local bar=""
    for ((j=0; j<filled; j++)); do bar="${bar}█"; done
    for ((j=0; j<empty; j++)); do bar="${bar}░"; done

    # Print progress bar with countdown number
    if [ "$i" -eq 0 ]; then
      printf "\r[%s] 📸 " "$bar"
    else
      local display=$(awk "BEGIN {printf \"%.1f\", $i/2}")
      printf "\r[%s] %s " "$bar" "$display"
    fi
    sleep .5
  done
  echo ""
}

# Loop forever
while true; do
  # Wait for spacebar
  read -rsn1 key_input
  if [ -z "$key_input" ]; then
    echo "Taking photo..."
    take_picture &
    countdown
  fi
done
