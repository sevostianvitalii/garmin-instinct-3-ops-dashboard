# The Ops Dashboard (Garmin Instinct 3)

A tactical, high-contrast dashboard for Garmin Instinct 2, 2X, and 3 series. Designed for immediate situational awareness without cycling through widgets.

![Icon](resources/drawables/launcher_icon.png)

## Features

- **MGRS Coordinates** (Center): High-visibility Military Grid Reference System readout.
- **Stealth Index** (Top): Instant visual check for active signals.
  - **Clear/Circle**: Stealth Mode (No BT, No Vibe).
  - **Filled Icon**: Active Signal (Bluetooth connected or Vibration enabled).
- **Barometric Trend** (Bottom): Visual pressure history graph (last 3 hours) to predict weather changes.
- **Astronomy Eye**:
  - **Moon Phase**: Accurate visual phase in the "Eye".
  - **Sun Event**: Progress ring indicating time to Sunset/Sunrise.
- **Time Overlay**: Current local time (HH:MM).

## Installation

### Method 1: Pre-compiled (Sideload)

**For Instinct 3 Solar**:

1. Download `OpsDashboard_I3Solar.prg` (from this repo).
2. Connect your watch via USB.
3. Copy the file to `GARMIN/APPS/`.

**For Instinct 2**:

1. Download `OpsDashboard.prg` (if available) or build from source using `instinct2` target.
2. Copy to `GARMIN/APPS/`.

**Note**: The widget "OpsDash" will appear in your main loop (Glances).

### Method 2: Build from Source

**Requirements**:

- Garmin Connect IQ SDK (System 7.x or higher)
- Visual Studio Code (Optional) or Command Line

**Steps**:

1. Clone this repository:

    ```bash
    git clone https://github.com/sevostianvitalii/garmin-instinct-3-ops-dashboard.git
    ```

2. Generate your developer key (if needed):

    ```bash
    openssl genrsa -out developer_key.pem 4096
    openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out developer_key.der -nocrypt
    ```

3. Build the project:

    ```bash
    ./build.sh
    ```

    *Note: Ensure your `monkeyc` path is set correctly in `build.sh`.*

## Configuration

This widget reads directly from system sensors.

- **GPS**: If MGRS shows "NO GPS", start a GPS activity (e.g., Navigate) to get a fix, then return to the dashboard. The last known position will be cached.
- **Colors**: Designed for 1-bit (B&W) high contrast displays (Instinct 2/3).

## Stealth Mode Logie

The top indicator simplifies status:

- **Bluetooth Icon**: Visible only if phone is connected.
- **Vibe/Sound Icon**: Visible if tones or vibration are enabled in System Settings.
- **Goal**: If the top area is empty (just circles), you are radio-silent and silent.

## Contributing

Pull requests are welcome. For major changes, open an issue first to discuss what you would like to change.

## License

MIT
