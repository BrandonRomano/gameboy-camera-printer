#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_BOY_PRINTER="$SCRIPT_DIR/gbp.sh"
GAME_BOY_CAMERA="$SCRIPT_DIR/gbc.sh"
INPUT_DIR="$SCRIPT_DIR/../input"
PROCESSED_DIR="$SCRIPT_DIR/../processed"
OUTPUT_DIR="$SCRIPT_DIR/../output"

process_photo() {
  local input_file="$1"
  local print_file="$OUTPUT_DIR/print.$(basename $input_file)"
  local digital_file="$OUTPUT_DIR/$(basename $input_file)"

  # Create a print file, and print it out
  "$GAME_BOY_CAMERA" "$input_file" "$print_file" "print"
  "$GAME_BOY_PRINTER" "$print_file"
  rm "$print_file"

  # Create a digital format to save in the output dir
  "$GAME_BOY_CAMERA" "$input_file" "$digital_file" "digital"

  # Moves the file out of the input dir so it is not processed again
  mv "$input_file" "$PROCESSED_DIR"
}

# Start the watcher
while true
do
	for file in "$INPUT_DIR/"*
	do
		if [[ $file == *".jpg" ]]; then
			process_photo $file
  		fi
	done
	sleep .1
done
