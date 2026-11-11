#!/bin/bash
# Installs (or updates) Tapper Pro on a Mac: downloads the right version for this
# Mac, puts it in Applications and opens it. Your projects are not touched.
set -e
RAW="https://raw.githubusercontent.com/suwanagit/TapperProPublic/main/mac"
if [ "$(uname -m)" = "arm64" ]; then KIND=AppleSilicon; else KIND=Intel; fi
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "  Downloading Tapper Pro…  (กำลังดาวน์โหลด Tapper Pro…)"
N=$(curl -fsSL "$RAW/$KIND.parts" | tr -d '[:space:]')
WANT=$(curl -fsSL "$RAW/$KIND.sha256" | tr -d '[:space:]')
: > "$TMP/tp.zip"
for ((i = 0; i < N; i++)); do
  echo "  part $((i + 1)) of $N"
  curl -fL --progress-bar --retry 3 "$RAW/$KIND.zip.part$i" >> "$TMP/tp.zip"
done
GOT=$(shasum -a 256 "$TMP/tp.zip" | cut -d' ' -f1)
if [ "$GOT" != "$WANT" ]; then
  echo ""
  echo "  ❌ The download didn't come through completely. Please check the internet and try again."
  echo "     (ดาวน์โหลดไม่ครบ กรุณาตรวจอินเทอร์เน็ตแล้วลองอีกครั้ง)"
  exit 1
fi

echo "  Installing…  (กำลังติดตั้ง…)"
osascript -e 'quit app "Tapper Pro"' >/dev/null 2>&1 || true
sleep 1
DEST="/Applications"
if ! [ -w "$DEST" ]; then DEST="$HOME/Applications"; mkdir -p "$DEST"; fi
rm -rf "$DEST/Tapper Pro.app"
/usr/bin/ditto -x -k "$TMP/tp.zip" "$DEST"
/usr/bin/xattr -dr com.apple.quarantine "$DEST/Tapper Pro.app" 2>/dev/null || true

echo ""
echo "  ✅ Done! Tapper Pro is installed.  (ติดตั้งเสร็จแล้ว!)"
echo "     You can close this window.  (ปิดหน้าต่างนี้ได้เลย)"
echo ""
open "$DEST/Tapper Pro.app"
