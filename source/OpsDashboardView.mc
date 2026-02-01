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
        var isStealth = true;
        
        var x = dc.getWidth() / 2;
        var y = 25; // Top area
        
        // Icons (Simulated with text/circles for MVP if no custom font)
        // BT
        if (settings.phoneConnected) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(x - 20, y, 4); // BT Indicator
            isStealth = false;
        } else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawCircle(x - 20, y, 4);
        }

        // Tones/Vibe (Simplified to just Vibe or skip if deprecated)
        // tonesEnabled is often unavailable in newer SDKs for WatchFaces/Widgets directly without permission or specific object
        if (settings.vibrateOn) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(x, y - 5, 4); // Sound/Vibe Indicator
            isStealth = false;
        } else {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawCircle(x, y - 5, 4);
        }
        
        // GPS (Check if position info is recent)
        var info = Position.getInfo();
        if (info.accuracy > Position.QUALITY_POOR) {
             dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
             dc.fillCircle(x + 20, y, 4); // GPS Indicator
             isStealth = false; // GPS is active/tracking
        } else {
             dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
             dc.drawCircle(x + 20, y, 4);
        }
    }

    // --- ZONE 2: MGRS (Center) ---
    function drawMGRS(dc) {
        var info = Position.getInfo();
        var coordString = "NO GPS";
        
        if (info != null && info.accuracy > Position.QUALITY_NOT_AVAILABLE) {
            // Get MGRS String
            var pos = info.position;
            if (pos != null) {
                coordString = pos.toGeoString(Position.GEO_MGRS);
            }
        }

        // Parse Standard MGRS: "4QFJ 12345 67890" -> "FJ" | "12345 67890"
        // Simplistic parsing for MVP
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        var w = dc.getWidth();
        var h = dc.getHeight();
        
        if (coordString.length() > 5) {
            // Assume format "GZD 100k EEEE NNNN"
            // We want to highlight the 100k ID and the Grid
            // Rough split: Space delimited
            
            // Draw Grid Zone Designator & 100km ID (approximate parsing)
            dc.drawText(w/2, h/2 - 20, fontMGRS, coordString, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(w/2, h/2 - 20, fontMGRS, coordString, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // --- ZONE 3: PRESSURE (Bottom) ---
    function drawPressureGraph(dc) {
        // Access history
        var history = SensorHistory.getPressureHistory({:period => 20, :order => SensorHistory.ORDER_NEWEST_FIRST});
        // Drawing logic would go here - simplified line for MVP
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        var bottom = height - 10;
        var graphHeight = 40;
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(20, bottom, width-20, bottom); // Base line
        
        // Mock Graph Line
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(20, bottom-10, width/2, bottom-20);
        dc.drawLine(width/2, bottom-20, width-20, bottom-5);
        
        // Current Value
        var sample = history.next();
        if (sample != null && sample.data != null) {
            var val = (sample.data / 100).format("%d"); // Pa -> hPa
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2, bottom - graphHeight - 5, fontSmall, val + " hPa", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // --- ZONE 4: EYE WINDOW (Custom) ---
    function drawEyeWindow(dc) {
        // Instinct 'Eye' is roughly at top right, usually around 2 o'clock position
        // On Instinct 2/3 it is a hardware circle. We can just draw in that area.
        // Approx coordinates for Instinct 2: 135, 35, radius 28 (Custom per device, using approximate absolute)
        
        var eyeX = dc.getWidth() - 40; 
        var eyeY = 40;
        var r = 25;

        // Draw Moon Phase (Simple Circle Phase)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(eyeX, eyeY, 10);
        dc.fillCircle(eyeX + 3, eyeY, 8); // Fake Waxing Gibbous
        
        // Draw Sunset Progress Ring
        dc.setPenWidth(3);
        dc.drawArc(eyeX, eyeY, r, Graphics.ARC_CLOCKWISE, 90, 0); // Mock progress
    }
}
