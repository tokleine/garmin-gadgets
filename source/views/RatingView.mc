using Toybox.WatchUi;
using Toybox.Graphics;

class RatingView extends WatchUi.View {
    private var _delegate;

    function initialize(del) {
        View.initialize();
        _delegate = del;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.RatingLayout(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_MEDIUM, "Rate Segment", Graphics.TEXT_JUSTIFY_CENTER);

        if (_delegate.selected_rating.equals("nice")) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_WHITE);
        } else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
        }
        dc.drawText(dc.getWidth() / 2, 130, Graphics.FONT_LARGE, _delegate.selected_rating.toUpper(), Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 240, Graphics.FONT_XTINY, "UP/DOWN: toggle nice/bad", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 260, Graphics.FONT_XTINY, "LAP/ENTER: confirm", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 280, Graphics.FONT_XTINY, "BACK: cancel", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class RatingViewDelegate extends WatchUi.InputDelegate {
    var selected_rating = "nice";
    private var _segment;

    function initialize(segment) {
        InputDelegate.initialize();
        _segment = segment;
    }

    // LAP or ENTER to confirm the rating
    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_LAP || key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            _saveAndPop();
            return true;
        }
        return false;
    }

    // DOWN button (nextPage) — toggle to "bad"
    function onNextPage() {
        selected_rating = "bad";
        WatchUi.requestUpdate();
        return true;
    }

    // UP button (previousPage) — toggle to "nice"
    function onPreviousPage() {
        selected_rating = "nice";
        WatchUi.requestUpdate();
        return true;
    }

    // BACK — cancel without saving
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    private function _saveAndPop() {
        if (_segment != null) {
            _segment.rating = selected_rating;
            StorageManager.addSegment(_segment);
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
