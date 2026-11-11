#!/bin/bash
# Installs (or updates) Tapper Pro on a Mac: downloads the right version for this
# Mac, puts it in Applications and opens it. Your projects are not touched.
set -e
REPO="suwanagit/TapperProPublic"
if [ "$(uname -m)" = "arm64" ]; then KIND=AppleSilicon; else KIND=Intel; fi
URL="https://github.com/$REPO/releases/latest/download/Tapper-Pro-mac-$KIND.app.zip"
TMP="$(mktemp -d)"
echo ""
echo "  Downloading Tapper Pro…  (กำลังดาวน์โหลด Tapper Pro…)"
curl -fL --progress-bar -o "$TMP/tp.zip" "$URL"
echo "  Installing…  (กำลังติดตั้ง…)"
osascript -e 'quit app "Tapper Pro"' >/dev/null 2>&1 || true
sleep 1
DEST="/Applications"
if ! [ -w "$DEST" ]; then DEST="$HOME/Applications"; mkdir -p "$DEST"; fi
rm -rf "$DEST/Tapper Pro.app"
/usr/bin/ditto -x -k "$TMP/tp.zip" "$DEST"
/usr/bin/xattr -dr com.apple.quarantine "$DEST/Tapper Pro.app" 2>/dev/null || true
rm -rf "$TMP"
echo ""
echo "  ✅ Done! Tapper Pro is in $DEST.  (ติดตั้งเสร็จแล้ว!)"
echo "     You can close this window.  (ปิดหน้าต่างนี้ได้เลย)"
echo ""
open "$DEST/Tapper Pro.app"
