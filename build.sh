#!/bin/bash
SDK_BIN="/home/user/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc/bin"

# Build specifically for the device likely used (Instinct 3 Solar is common, or just build generic export)
# Using -e (export) creates an .iq file, but for sideloading we need a .prg
# We must specify the EXACT target device for a PRG sideload.
# A .prg built for 'instinct2' WILL NOT RUN on 'instinct3'.

echo "Building for Instinct 3 Solar 45mm..."
$SDK_BIN/monkeyc \
    -o OpsDashboard_I3Solar.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct3solar45mm \
    -w

echo "Building for Instinct 2..."
$SDK_BIN/monkeyc \
    -o OpsDashboard.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct2 \
    -w

echo "Done. Use OpsDashboard_I3Solar.prg for Instinct 3 Solar."
