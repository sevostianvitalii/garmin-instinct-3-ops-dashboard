#!/bin/bash
SDK_BIN="/home/user/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc/bin"
$SDK_BIN/monkeyc \
    -o OpsDashboard.prg \
    -f monkey.jungle \
    -y developer_key.der \
    -d instinct2 \
    -w
