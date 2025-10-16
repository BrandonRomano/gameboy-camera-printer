#!/usr/bin/env bash
# Depends on imagesnap, which can be installed via `brew install imagesnap`

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/../input"

take_picture() {
  # To determine the device: imagesnap -l
  imagesnap -d "6700" "$INPUT_DIR/capture.jpg" > /dev/null # TODO: increment the number here
}

countdown() {
  local total=6
  for i in 6 5 4 3 2 1 0; do
    local progress=$((total - i))
    local filled=$((progress * 20 / total))
    local empty=$((20 - filled))

    # Build progress bar
    local bar=""
    for ((j=0; j<filled; j++)); do bar="${bar}█"; done
    for ((j=0; j<empty; j++)); do bar="${bar}░"; done

    # Print progress bar with countdown number
    printf "\r[%s] %d " "$bar" "$i"
    sleep .5
  done
  echo ""  # New line after countdown completes
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
