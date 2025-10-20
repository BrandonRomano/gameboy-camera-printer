#!/usr/bin/env bash
#
# $1: Input File
# $2: Output File
# $3: Print Option, either one of: ['print', 'digital']

INPUT_FILE="$1"
OUTPUT_FILE="$2"
PRINT_OPTION="$3"
TMP_INTERMEDIARY="$(dirname ${INPUT_FILE%.*})/$(basename ${INPUT_FILE%.*}).unscaled.png"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Determine the background image that we're going to use. If there
# is an override image, we prefer that, else use the default.
BACKGROUND_OVERRIDE="$SCRIPT_DIR/background-override.png"
if [[ -f "$BACKGROUND_OVERRIDE" ]]; then
  BACKGROUND_IMAGE="$BACKGROUND_OVERRIDE"
else
  BACKGROUND_IMAGE="$SCRIPT_DIR/background.png"
fi

# The 'digital' dither config is near-identical to how the actual
# Game Boy Camera renders.
dither_config="o8x8,4"
if [[ "$PRINT_OPTION" = "print" ]]; then
  # This is increased resolution to offset the additional
  # layer of dithering that will have to occur when this
  # gets sent off to our printer.
  dither_config="o2x2,16"
fi

# We convert our image to a black and white image of the correct
# size, and have a temporary image here so we can place it on the
# background template.
magick "$INPUT_FILE" \
  -resize 128x112^ \
  -gravity center \
  -extent 128x112 \
  -colorspace Gray \
  -brightness-contrast 0x40 \
  -ordered-dither "$dither_config" \
  -scale 200% \
  +append \
  "$TMP_INTERMEDIARY"

# Generate the final image
magick "$BACKGROUND_IMAGE" "$TMP_INTERMEDIARY" \
  -gravity center \
  -composite \
  -flop \
  -scale 200% \
  "$OUTPUT_FILE"

# Remove the temporary intermediary file.
rm "$TMP_INTERMEDIARY"
