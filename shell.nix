# shell.nix
# Author: D.A.Pelasgus
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "font-image-env";

  buildInputs = [
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.python3Packages.fonttools
    pkgs.python3Packages.setuptools  # in case notofonttools needs it
    pkgs.imagemagick
    pkgs.optipng
    pkgs.zopfli
    pkgs.pngquant
  ];

  shellHook = ''
    echo "Upgrading pip and installing notofonttools in a virtual environment..."

    # Optional: Create and enter virtual environment
    if [ ! -d .venv ]; then
      python -m venv .venv
    fi
    source .venv/bin/activate

    pip install --upgrade pip
    pip install notofonttools
  '';
}
