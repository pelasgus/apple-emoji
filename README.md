![AppleColorEmojiLinux](https://repository-images.githubusercontent.com/158348890/44a361ad-d9f3-4b7b-8b57-fd3198ec9952)
Makes Apple's vibrant emojis available on Linux.

>[!IMPORTANT]
> Please note that this project is for educational purposes only. Apple is a trademark of Apple Inc., registered in the U.S. and other countries.

## 🚀 | PRE-BUILT BINARIES
- Download the [latest release](https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf) of `AppleColorEmoji.ttf`.
- Copy `AppleColorEmoji.ttf` to `~/.local/share/fonts`.
```sh
cp AppleColorEmoji.ttf ~/.local/share/fonts/
```
- Rebuild the font cache with `fc-cache -f -v`.

## 🛠 | BUILDING FROM SOURCE
The provided [flake.nix](./flake.nix) or [shell.nix](shell.nix) can be used to automatically acquire dependencies, or handle them manually and build from source:

### DEPENDENCY MANAGEMENT | THE FLAKE WAY
```sh
git clone git@github.com:samuelngs/apple-emoji-linux.git
cd apple-emoji-linux
nix shell .#apple-emoji-linux
```
or import the flake in your `flake.nix`:
```nix
# Apple Emoji Font
inputs.apple-emoji.url = "github:typedrat/apple-emoji-linux?ref=fix-flake-on-unstable";
inputs.apple-emoji.inputs.nixpkgs.follows = "nixpkgs";
outputs = { self, nixpkgs, home-manager, apple-emoji, ... } @ inputs: 
  # Variable Declaration
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
  packages.${system} = {
    apple-emoji = apple-emoji.packages.${system}.default;
  };
```
### DEPENDENCY MANAGEMENT | THE SHELL WAY
```sh
git clone git@github.com:samuelngs/apple-emoji-linux.git
cd apple-emoji-linux
nix-shell shell.nix
```
### DEPENDENCY MANAGEMENT | THE MANUAL WAY
- Install Python 3; the process currently requires a Python 3.x wide build.
- Install the [fonttools Python package](https://github.com/fonttools/fonttools):
```python
python -m pip install fonttools
```
- Install the [nototools Python package](https://github.com/googlei18n/nototools):
```sh
python -m pip install https://github.com/googlefonts/nototools/archive/v0.2.1.tar.gz
```
or clone from [here](https://github.com/googlei18n/nototools) and follow the instructions.
- Install image optimization tools: [Optipng](http://optipng.sourceforge.net/), [Zopfli](https://github.com/google/zopfli), [Pngquant](https://pngquant.org/), and [ImageMagick](https://www.imagemagick.org/).
  - On yum-based systems:
    ```sh
    yum install optipng zopfli pngquant imagemagick
    ```
  - On dnf-based:
    ```sh
    dnf install optipng zopfli pngquant imagemagick
    ```
  - On apt-based:
    ```sh
    apt-get install optipng zopfli pngquant imagemagick
    ```
  - On pacman-based:
- Clone the [source repository](https://github.com/samuelngs/apple-emoji-linux) from GitHub.
- Open a terminal, navigate to the directory
- Run:
```sh
make -j
make install
```
- Rebuild your system font cache with `fc-cache -f -v`.


## USAGE

AppleColorEmoji uses the CBDT/CBLC color font format, which is supported by Android and Chrome/Chromium OS. Windows supports it starting with Windows 10 Anniversary Update in Chrome and Edge. On macOS, only Chrome supports it, while on Linux, it will support it with some fontconfig tweaking.

### via NIX via Stylix


## 🎨 Color Emoji Assets

Uncover the assets used to craft AppleColorEmoji, showcasing the diverse world of emojis. Note: some characters share assets, particularly gender-neutral ones. Refer to the `emoji_aliases.txt` file for aliasing definitions.

🚨 Please be aware that images in the font may differ from the original assets, with flag images being PNGs featuring standardized sizes and creative transforms.

## 🙌 Credits

- [googlei18n/noto-emoji](https://github.com/googlei18n/noto-emoji)
- [googlei18n/nototools](https://github.com/googlei18n/nototools)

## 📜 License

- Emoji fonts (under the fonts subdirectory) are under the [SIL Open Font License, version 1.1](fonts/LICENSE).
- Tools and some image resources are under the [Apache license, version 2.0](./LICENSE).
