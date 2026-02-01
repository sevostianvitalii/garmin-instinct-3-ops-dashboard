#!/bin/bash
SDK_BIN="/home/user/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc/bin"

echo "Building for Instinct 3 Solar 45mm (Standard I3)..."
$SDK_BIN/monkeyc \
    -o OpsDashboard_I3Solar.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct3solar45mm \
    -w

echo "Building for Instinct 2X (50mm)..."
# User may have an I2X which is 50mm, sometimes confused with I3
$SDK_BIN/monkeyc \
    -o OpsDashboard_I2X.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct2x \
    -w

echo "Building for Instinct 3 AMOLED 50mm (High Res)..."
$SDK_BIN/monkeyc \
    -o OpsDashboard_I3Amoled50.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct3amoled50mm \
    -w

echo "Done. Please choose the PRG that matches your device."
