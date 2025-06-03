# Copyright 2025 D.A.Pelasgus All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set shell to bash for more robust scripting
set shell := ["bash", "-cu"]

# Variables
emoji := AppleColorEmoji
font := "{{emoji}}.ttf"
body_dimensions := "160x160"
imops := "-size {{body_dimensions}} canvas:none -compose copy -gravity center"

pngquant := pngquant
zopflipng := zopflipng
optipng := optipng

python := python3
prefix := "{{env_var("HOME")}}/.local"

emoji_src_dir := png/160
build_dir := build
emoji_dir := "{{build_dir}}/emoji"
quantized_dir := "{{build_dir}}/quantized_pngs"
compressed_dir := "{{build_dir}}/compressed_pngs"

add_glyphs := add_glyphs.py
add_glyphs_flags := "-a emoji_aliases.txt"
emoji_builder := third_party/color_emoji/emoji_builder.py
pua_adder := map_pua_emoji.py
vs_adder := add_vs_cmap.py
small_metrics := -S

# Default recipe
default:
	just emoji

# Ensure build dirs exist
make-dirs:
	mkdir -p {{emoji_dir}} {{quantized_dir}} {{compressed_dir}}

# Build emoji images
emoji:
	just make-dirs
	for f in {{emoji_src_dir}}/emoji_u*.png; do \
	  name=$$(basename $$f); \
	  convert {{imops}} "$$f" -composite "PNG32:{{emoji_dir}}/$$name"; \
	done

# Quantize PNGs
quantized:
	just emoji
	for f in {{emoji_dir}}/*.png; do \
	  name=$$(basename $$f); \
	  out="{{quantized_dir}}/$$name"; \
	  if ! {{pngquant}} --speed 1 --skip-if-larger --quality 85-95 --force -o "$$out" "$$f"; then \
	    echo "reuse $$f"; \
	    cp "$$f" "$$out"; \
	  fi; \
	done

# Compress PNGs
compressed:
	just quantized
	if command -v {{zopflipng}} >/dev/null; then \
	  echo "using zopflipng"; \
	  for f in {{quantized_dir}}/*.png; do \
	    name=$$(basename $$f); \
	    {{zopflipng}} -y "$$f" "{{compressed_dir}}/$$name" >/dev/null 2>&1; \
	  done; \
	else \
	  echo "zopflipng not found, using optipng"; \
	  for f in {{quantized_dir}}/*.png; do \
	    name=$$(basename $$f); \
	    {{optipng}} -quiet -o7 -clobber -force -out "{{compressed_dir}}/$$name" "$$f"; \
	  done; \
	fi

# Generate .ttx from template and add glyphs
ttx file:
	{{python}} {{add_glyphs}} -f {{file}}.ttx.tmpl -o {{file}}.ttx -d "{{compressed_dir}}" {{add_glyphs_flags}}

# Build .ttf from .ttx
ttf file:
	rm -f {{file}}.ttf
	ttx {{file}}.ttx

# Full font build
font:
	just compressed
	if ! command -v {{vs_adder}} >/dev/null; then \
	  echo "ERROR: {{vs_adder}} not found in PATH" >&2; \
	  exit 1; \
	fi
	{{python}} {{emoji_builder}} {{small_metrics}} -V "{{emoji}}.tmpl.ttf" "{{emoji}}.ttf" "{{compressed_dir}}/emoji_u"
	{{python}} {{pua_adder}} "{{emoji}}.ttf" "{{emoji}}-with-pua"
	{{vs_adder}} -vs 2640 2642 2695 --dstdir '.' -o "{{emoji}}-with-pua-varsel" "{{emoji}}-with-pua"
	mv "{{emoji}}-with-pua-varsel" "{{emoji}}.ttf"
	rm "{{emoji}}-with-pua"

# Install font
install:
	mkdir -p {{prefix}}/share/fonts
	cp -f {{emoji}}.ttf {{prefix}}/share/fonts/

# Clean build artifacts
clean:
	rm -f {{emoji}}.ttf {{emoji}}.tmpl.ttf {{emoji}}.tmpl.ttx
	rm -rf {{build_dir}}
