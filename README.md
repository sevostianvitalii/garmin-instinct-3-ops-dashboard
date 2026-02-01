# The Ops Dashboard (Garmin Instinct 3)

A tactical, high-contrast dashboard for Garmin Instinct 2, 2X, and 3 series. Designed for immediate situational awareness without cycling through widgets.

![Icon](resources/drawables/launcher_icon.png)

## Features

- **MGRS Coordinates** (Center): High-visibility Military Grid Reference System readout.
- **Stealth Index** (Top): Instant visual check for active signals.
  - **Clear/Circle**: Stealth Mode (No BT, No Vibe).
  - **Filled Icon**: Active Signal (Bluetooth connected or Vibration enabled).
- **Barometric Trend** (Bottom): Visual pressure history graph (last 3 hours).
- **Astronomy Eye**:
  - **Moon Phase**: Accurate visual phase in the "Eye".
  - **Sun Event**: Progress ring indicating time to Sunset/Sunrise.
- **Time Overlay**: Current local time (HH:MM).

## Installation

### Method 1: Pre-compiled (Sideload)

Choose the file that matches your specific device size and screen type:

| Device Type | File Name | Note |
| :--- | :--- | :--- |
| **Instinct 3 Solar (45mm/Standard)** | `OpsDashboard_I3Solar.prg` | Standard MIP Display |
| **Instinct 2X (50mm)** | `OpsDashboard_I2X.prg` | Large Format MIP Display |
| **Instinct 3 AMOLED (50mm)** | `OpsDashboard_I3Amoled50.prg` | High-Res Display |

1. Download the matching `.prg` file.
2. Connect your watch via USB.
3. Copy the file to `GARMIN/APPS/`.

**Note**: The widget "OpsDash" will appear in your main loop (Glances).

### Method 2: Build from Source

...
