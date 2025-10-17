# Game Boy Camera & Printer

Gameboy Camera & Printer are two scripts which mimic a [Game Boy Camera](https://en.wikipedia.org/wiki/Game_Boy_Camera) and a [Game Boy Printer](https://en.wikipedia.org/wiki/Game_Boy_Printer).

|                                                  Input                                                   |                                              Digital Output                                              |                                               Print Output                                               |
| :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/ba53211a-5e34-47a6-845a-dc5a9ee4e986" height="250"> | <img src="https://github.com/user-attachments/assets/d3dc1c9a-6648-438a-8988-fbe8f67a2598" height="250"> | <img src="https://github.com/user-attachments/assets/5c96eaa7-60d6-4110-9759-3c1f6e4077c5" height="250"> |

## Usage

```sh
# Copy the `.env.sample` file & modify the values in the `.env` file.
cp .env.sample .env && $EDITOR .env
# To start the script
make watch
```

The script will begin listening for images to appear in the `input` directory. Once an image appears, the image will be processed by `gbc.sh` and then it will be sent to the configured printer as well as the `output` directory.

A [Thermal Printer](https://en.wikipedia.org/wiki/Game_Boy_Printer#Thermal_paper) is strongly recommended.

## Dependencies

- [ImageMagick](https://imagemagick.org)
- [Python](https://www.python.org/downloads/)
- [imagesnap](https://github.com/rharder/imagesnap)
