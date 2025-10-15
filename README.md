# Game Boy Camera & Printer

Gameboy Camera & Printer are two scripts which mimic a [Game Boy Camera](https://en.wikipedia.org/wiki/Game_Boy_Camera) and a [Game Boy Printer](https://en.wikipedia.org/wiki/Game_Boy_Printer).

## Usage

```sh
make watch
```

The script will begin listening for images to appear in the `input` directory.

Once an image appears, the image will be processed by `gbc.sh` and then it will be sent to the configured printer as well as the `output` directory.

A [Thermal Printer](https://en.wikipedia.org/wiki/Game_Boy_Printer#Thermal_paper) is strongly recommended.
