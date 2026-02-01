#!/bin/bash
SDK_BIN="/home/user/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc/bin"

echo "Building v2 (Native I3 Solar) for fit tests..."
# Using the native I3 target (which worked before) but with the NEW layout and NEW AppID
$SDK_BIN/monkeyc \
    -o OpsDashboard_v2_I3Solar.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct3solar45mm \
    -w

echo "Done. Use OpsDashboard_v2_I3Solar.prg"
