using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

class MainView extends WatchUi.View {
    private var app;

    function initialize() {
        View.initialize();
        app = Application.getApp();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        var status_text;
        if (app.getIsRecording()) {
            status_text = "RECORDING";
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
        } else {
            status_text = "Ready";
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        }

        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_LARGE, "Road Rater", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 120, Graphics.FONT_MEDIUM, status_text, Graphics.TEXT_JUSTIFY_CENTER);

        var segments = StorageManager.getSegments();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 200, Graphics.FONT_SMALL, "Segments: " + segments.size(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 260, Graphics.FONT_XTINY, "ENTER: Start/Stop  MENU: List", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class MainViewDelegate extends WatchUi.InputDelegate {
    private var app;

    function initialize() {
        InputDelegate.initialize();
        app = Application.getApp();
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ENTER) {
            if (app.getIsRecording()) {
                var segment = app.stopRecording();
                if (segment != null) {
                    var rating_del = new RatingViewDelegate(segment);
                    WatchUi.pushView(new RatingView(rating_del), rating_del, WatchUi.SLIDE_LEFT);
                }
            } else {
                app.startRecording();
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_MENU) {
            var list_view = new ListingsView();
            WatchUi.pushView(list_view, new ListingsViewDelegate(list_view), WatchUi.SLIDE_LEFT);
            return true;
        }

        return false;
    }
}
