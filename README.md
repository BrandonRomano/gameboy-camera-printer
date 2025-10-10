# Game Boy Camera & Printer

Gameboy Camera & Printer are two scripts which mimic a [Game Boy Camera](https://en.wikipedia.org/wiki/Game_Boy_Camera) and a [Game Boy Printer](https://en.wikipedia.org/wiki/Game_Boy_Printer).

## Game Boy Printer Usage

```sh
./gbp.sh
```

The script will begin listening for images to appear in the `input` directory.

Once an image appears, the image will be processed by `gbc.sh` and then it will be sent to the configured printer as well as the `output` directory.

A [Thermal Printer](https://en.wikipedia.org/wiki/Game_Boy_Printer#Thermal_paper) is strongly recommended.

## Game Boy Camera Usage

```sh
./gbc.sh luna.png
```

Input (luna.png)             |  Output (gbc-luna.png)
:-------------------------:|:-------------------------:
<img src="https://github.com/user-attachments/assets/ba53211a-5e34-47a6-845a-dc5a9ee4e986" height="250">  |  <img src="https://github.com/user-attachments/assets/d3dc1c9a-6648-438a-8988-fbe8f67a2598" height="250">

## Dependencies

- [ImageMagick](https://imagemagick.org)
