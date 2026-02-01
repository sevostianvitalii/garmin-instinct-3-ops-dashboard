using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Position;
using Toybox.SensorHistory;
using Toybox.Time;
using Toybox.Math;

class OpsDashboardView extends WatchUi.View {

    // Fonts
    var fontMGRS;
    var fontSmall;
    var fontIcons;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        // Load fonts if custom, otherwise use system
        fontMGRS = Graphics.FONT_LARGE; // Placeholder for Tactical Font
        fontSmall = Graphics.FONT_XTINY;
    }

    function onShow() {
    }

    function onUpdate(dc) {
        // 1. Clear Screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // 2. Draw Zones
        drawStealthIndex(dc);
        drawMGRS(dc);
        drawPressureGraph(dc);
        drawEyeWindow(dc);
        drawTime(dc);
    }

    // --- OVERLAY: TIME (Bottom Right or Custom) ---
    function drawTime(dc) {
        var clockTime = System.getClockTime();
        var timeStr = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        
        // Draw slightly above pressure graph or in a dedicated spot
        // For Tactical Grid, maybe simple overlay in lower right or just under MGRS
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // Drawing just below center MGRS
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 15, fontSmall, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // --- ZONE 1: STEALTH INDEX (Top) ---
    function drawStealthIndex(dc) {
        var settings = System.getDeviceSettings();
        
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cy = h * 0.15; // Top area
        var cx = w / 2;
        var spacing = w * 0.18;
        
        // Font for indicators
        var fontInd = Graphics.FONT_XTINY;

        // Draw "Tactical" Text Indicators
        
        // 1. BT (Left)
        if (settings.phoneConnected) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); // Active
            dc.drawText(cx - spacing, cy, fontInd, "BT", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT); // Inactive
            dc.drawText(cx - spacing, cy, fontInd, "BT", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // 2. VIBE/TONE (Center)
        // If everything is silent/off = STEALTH
        if (settings.vibrateOn) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, cy, fontInd, "VIB", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
             // In stealth/silent mode, shows dimmed or "SLNT"? 
             // Keeping it consistent: Dimmed tag
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, cy, fontInd, "VIB", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        
        // 3. GPS (Right)
        var info = Position.getInfo();
        var gpsActive = (info.accuracy > Position.QUALITY_POOR);
        if (gpsActive) {
             dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
             dc.drawText(cx + spacing, cy, fontInd, "GPS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER); 
        } else {
             dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
             dc.drawText(cx + spacing, cy, fontInd, "GPS", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    // --- ZONE 2: MGRS (Center) ---
    function drawMGRS(dc) {
        var info = Position.getInfo();
        var coordString = "NO GPS";
        
        if (info != null && info.accuracy > Position.QUALITY_NOT_AVAILABLE) {
            var pos = info.position;
            if (pos != null) {
                coordString = pos.toGeoString(Position.GEO_MGRS);
            }
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var w = dc.getWidth();
        var h = dc.getHeight();
        var centerY = h / 2;
        
        // Split String logic
        // Standard MGRS: "4QFJ 12345 67890" (approx 16-18 chars)
        // This is too wide for Large Font on one line.
        // Split into:
        // Line 1: "4Q FJ" (GZD + 100k)
        // Line 2: "12345 67890" (Coords)
        
        // Find split point (first space usually)
        var splitIdx = coordString.find(" ");
        var line1 = coordString;
        var line2 = "";
        
        if (splitIdx != null) {
            // Check for second space (GZD 100k Digits)
            var remainder = coordString.substring(splitIdx + 1, coordString.length());
            var secondSpace = remainder.find(" ");
            
            if (secondSpace != null) {
                // Format: "4Q FJ 12345 67890"
                // Line 1: "4Q FJ"
                // Line 2: "12345 67890"
                var totalSplit = splitIdx + 1 + secondSpace;
                line1 = coordString.substring(0, totalSplit);
                line2 = coordString.substring(totalSplit + 1, coordString.length());
            } else {
                 // Format: "4QFJ 1234567890" or similar
                 line1 = coordString.substring(0, splitIdx);
                 line2 = remainder;
            }
        }
        
        if (line2.length() > 0) {
            // Two Lines
            // Line 1 (GZD) slightly smaller or same
            dc.drawText(w/2, centerY - (h * 0.12), Graphics.FONT_MEDIUM, line1, Graphics.TEXT_JUSTIFY_CENTER);
            // Line 2 (Grid) Large
            dc.drawText(w/2, centerY + (h * 0.02), Graphics.FONT_LARGE, line2, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
             // Single Line fallback (e.g. NO GPS)
             dc.drawText(w/2, centerY - 10, Graphics.FONT_MEDIUM, coordString, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // --- ZONE 3: PRESSURE (Bottom) ---
    function drawPressureGraph(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var bottom = height * 0.85; // Bottom Area
        var graphHeight = height * 0.15;
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(width * 0.2, bottom, width * 0.8, bottom); // Base line
        
        // Mock Graph
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(width * 0.2, bottom - (graphHeight*0.3), width * 0.5, bottom - (graphHeight*0.6));
        dc.drawLine(width * 0.5, bottom - (graphHeight*0.6), width * 0.8, bottom - (graphHeight*0.2));
        
        // Value
        var history = SensorHistory.getPressureHistory({:period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST});
        var sample = history.next();
        if (sample != null && sample.data != null) {
            var val = (sample.data / 100).format("%d");
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2, bottom + 5, fontSmall, val + " hPa", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // --- ZONE 4: EYE WINDOW (Custom) ---
    function drawEyeWindow(dc) {
        // Dynamic Eye Position (Top Right ~2 o'clock)
        var w = dc.getWidth();
        
        // Approx Eye Center for Instinct series is usually ~75% width, ~20% height
        var eyeX = w * 0.77; 
        var eyeY = w * 0.22;
        var r = w * 0.14; // Radius relative to screen size relative to 'Eye' cutout

        // Draw Moon Phase
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(eyeX, eyeY, r * 0.5);
        dc.fillCircle(eyeX + (r*0.1), eyeY, r * 0.4); 
        
        // Draw Sunset Ring
        dc.setPenWidth(3);
        dc.drawArc(eyeX, eyeY, r, Graphics.ARC_CLOCKWISE, 90, 0); 
    }
}
