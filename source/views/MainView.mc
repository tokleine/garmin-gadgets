using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class MainView extends WatchUi.View {
    private var app;
    private var recording_status_text = "Ready";

    function initialize() {
        View.initialize();
        app = Application.getApp();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        if (app.getIsRecording()) {
            recording_status_text = "RECORDING";
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
        } else {
            recording_status_text = "Ready";
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        }

        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_LARGE, "Road Rater", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 120, Graphics.FONT_MEDIUM, recording_status_text, Graphics.TEXT_JUSTIFY_CENTER);

        var segments = StorageManager.getSegments();
        var segment_count = segments.size();
        var status_text = "Segments: " + segment_count;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 200, Graphics.FONT_SMALL, status_text, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(dc.getWidth() / 2, 260, Graphics.FONT_XTINY, "MENU: Options", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class MainViewDelegate extends WatchUi.InputDelegate {
    private var view;
    private var app;

    function initialize(main_view) {
        InputDelegate.initialize();
        view = main_view;
        app = Application.getApp();
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ENTER) {
            if (app.getIsRecording()) {
                app.stopRecording();
                var segment = app.stopRecording();
                if (segment != null) {
                    WatchUi.pushView(new RatingView(segment), new RatingViewDelegate(), WatchUi.SLIDE_LEFT);
                }
            } else {
                app.startRecording();
            }
            return true;
        } else if (key == WatchUi.KEY_MENU) {
            WatchUi.pushView(new ListingsView(), new ListingsViewDelegate(), WatchUi.SLIDE_LEFT);
            return true;
        }

        return false;
    }
}
