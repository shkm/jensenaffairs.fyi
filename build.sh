#!/bin/sh
# Builds the site into public/, substituting {{COUNT}} from the COUNT file.
set -eu
cd "$(dirname "$0")"

count=$(tr -d '[:space:]' < COUNT)
case $count in
  '' | *[!0-9]*) echo "COUNT must be a whole number, got '$count'" >&2; exit 1 ;;
esac

mkdir -p public
for f in index.html index.json og.svg favicon.svg; do
  sed "s/{{COUNT}}/$count/g" "src/$f" > "public/$f"
done
cp src/jacket.svg src/CNAME public/
rsvg-convert public/og.svg -o public/og.png
rsvg-convert -w 32 public/favicon.svg -o public/favicon.png
rsvg-convert -w 180 public/favicon.svg -o public/apple-touch-icon.png

echo "Built public/ with count $count"
