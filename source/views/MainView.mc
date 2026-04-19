using Toybox.WatchUi;
using Toybox.Graphics;
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
        dc.drawText(dc.getWidth() / 2, 260, Graphics.FONT_XTINY, "LAP: Start/Stop", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 280, Graphics.FONT_XTINY, "DOWN: View list", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class MainViewDelegate extends WatchUi.InputDelegate {
    private var app;

    function initialize() {
        InputDelegate.initialize();
        app = Application.getApp();
    }

    // On Edge 540, the physical LAP button sends KEY_ESC (5), not KEY_LAP (19)
    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_ESC || key == WatchUi.KEY_LAP || key == WatchUi.KEY_START || key == WatchUi.KEY_ENTER) {
            _toggleRecording();
            return true;
        }
        return false;
    }

    // DOWN button (nextPage behavior) — open segment list
    function onNextPage() {
        var list_view = new ListingsView();
        WatchUi.pushView(list_view, new ListingsViewDelegate(list_view), WatchUi.SLIDE_UP);
        return true;
    }

    // UP button (previousPage behavior) — no-op on main screen
    function onPreviousPage() {
        return true;
    }

    // Long-press menu — open segment list
    function onMenu() {
        var list_view = new ListingsView();
        WatchUi.pushView(list_view, new ListingsViewDelegate(list_view), WatchUi.SLIDE_LEFT);
        return true;
    }

    private function _toggleRecording() {
        if (app.getIsRecording()) {
            var segment = app.stopRecording();
            if (segment != null) {
                var rating_del = new RatingViewDelegate(segment);
                WatchUi.pushView(new RatingView(rating_del), rating_del, WatchUi.SLIDE_LEFT);
            } else {
                WatchUi.requestUpdate();
            }
        } else {
            app.startRecording();
            WatchUi.requestUpdate();
        }
    }
}
