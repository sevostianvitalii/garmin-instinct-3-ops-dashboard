#!/bin/bash
# Workaround for Kali/Debian Rolling missing libwebkit2gtk-4.0
# Requires: libwebkit2gtk-4.1-0 installed
# (sudo apt install libwebkit2gtk-4.1-0)

SDK_DIR="/home/user/Downloads/connectiq-sdk-manager-linux"
LIB_FIX_DIR="$SDK_DIR/lib_fix"

echo "Setting up WebKit shim..."
mkdir -p "$LIB_FIX_DIR"

# Find system 4.1 library
LIB_41=$(find /usr/lib -name "libwebkit2gtk-4.1.so.0" | head -n 1)

if [ -z "$LIB_41" ]; then
    echo "Error: libwebkit2gtk-4.1.so.0 not found. Please run: sudo apt install libwebkit2gtk-4.1-0"
    exit 1
fi

echo "Found 4.1 at: $LIB_41"
# Create symlinks
ln -sf "$LIB_41" "$LIB_FIX_DIR/libwebkit2gtk-4.0.so.37"
ln -sf "$LIB_41" "$LIB_FIX_DIR/libwebkit2gtk-4.0.so"

# Also need libjavascriptcoregtk-4.0
JS_LIB_41=$(find /usr/lib -name "libjavascriptcoregtk-4.1.so.0" | head -n 1)
if [ -n "$JS_LIB_41" ]; then
    ln -sf "$JS_LIB_41" "$LIB_FIX_DIR/libjavascriptcoregtk-4.0.so.18"
fi

# Fix for libsoup (SDK needs 2.4, system has 3.0)
SOUP_LIB_3=$(find /usr/lib -name "libsoup-3.0.so.0" | head -n 1)
if [ -n "$SOUP_LIB_3" ]; then
    echo "Found libsoup-3.0 at: $SOUP_LIB_3. Creating shim for 2.4..."
    ln -sf "$SOUP_LIB_3" "$LIB_FIX_DIR/libsoup-2.4.so.1"
else
    echo "Warning: libsoup-3.0 not found. SDK Manager might fail."
fi

# Fix for libjpeg (SDK needs 8, system has 62)
JPEG_LIB_62=$(find /usr/lib -name "libjpeg.so.62" | head -n 1)
if [ -n "$JPEG_LIB_62" ]; then
    echo "Found libjpeg.so.62 at: $JPEG_LIB_62. Creating shim for libjpeg.so.8..."
    ln -sf "$JPEG_LIB_62" "$LIB_FIX_DIR/libjpeg.so.8"
    ln -sf "$JPEG_LIB_62" "$LIB_FIX_DIR/libjpeg.so"
fi

# Fix for libpng (SDK often needs 12, system usually has 16) - Preemptive
PNG_LIB_16=$(find /usr/lib -name "libpng16.so.16" | head -n 1)
if [ -n "$PNG_LIB_16" ]; then
     # Create shim for libpng12 if needed (common failure point)
     ln -sf "$PNG_LIB_16" "$LIB_FIX_DIR/libpng12.so.0"
fi

echo "Launching SDK Manager with LD_LIBRARY_PATH..."
export LD_LIBRARY_PATH="$LIB_FIX_DIR:$LD_LIBRARY_PATH"
"$SDK_DIR/bin/sdkmanager" &
