#!/bin/bash
#
# $1: The image file to print
INPUT_FILE="$1"

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# We're using python's virtual environment to manage packages, so
# we need to rely on the binary provided by the venv.
# https://docs.python.org/3/library/venv.html
PYTHON="$SCRIPT_DIR/esc-pos-image/.venv/bin/python"

#
# Makes a call to a Python script, which converts the input image into a
# ESC/POS Raster Image, sending the result to stdout. There is some opinion
# applied in the script, which involves both scaling & dithering.
# https://escpos.readthedocs.io/en/latest/imaging.html#raster-image-1d-76-30-m-xl-xh-yl-yh-d1-dk-rel-phx
#
# @param $1: a path to an Image to convert
# @stdout: The ESC/POS raster image bytes.
#
esc_pos_raster_image() {
  "$PYTHON" "$SCRIPT_DIR/esc-pos-image/main.py" --width "$GBCP_PRINTER_WIDTH_PX" "$1"
}

#
# $1: The text to be left aligned
# #2: The text to be right aligned
#
esc_pos_left_and_right_aligned_text() {
  local left_text="$1"
  local right_text="$2"
  local left_len="${#left_text}"
  local right_len="${#right_text}"
  local spaces=$((GBCP_PRINTER_WIDTH_COLUMNS - left_len - right_len))
  printf "\n%s%*s%s" "$left_text" "$spaces" "" "$right_text"
}

# Print out the image file
(
  # First we print the image
  esc_pos_raster_image "$INPUT_FILE"
  printf '\n'
  # Add any configured print description
  esc_pos_left_and_right_aligned_text "$GBCP_PRINT_DESCRIPTION" "$(date +%m/%d/%Y)"
  # Empty lines, for padding
  printf '\n%.0s' $(seq 1 "$GBCP_PRINTER_LINE_PADDING")
  # Cut command
  printf '\x1d\x56\x00'
) | lp -d "$GBCP_PRINTER_NAME" -o raw
