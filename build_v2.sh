#!/bin/bash
SDK_BIN="/home/user/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc/bin"

echo "Building v2 for Instinct 2X / 3 Standard (Universal)..."
# Generating a v2 binary to distinguish for user
$SDK_BIN/monkeyc \
    -o OpsDashboard_v2_I2X.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct2x \
    -w

echo "Done. Use OpsDashboard_v2_I2X.prg"
