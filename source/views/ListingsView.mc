using Toybox.WatchUi;
using Toybox.Graphics;

class ListingsView extends WatchUi.View {
    var segments;
    var selected_index = 0;

    function initialize() {
        View.initialize();
        segments = StorageManager.getSegments();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ListLayout(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 20, Graphics.FONT_MEDIUM, "Segments", Graphics.TEXT_JUSTIFY_CENTER);

        if (segments.size() == 0) {
            dc.drawText(dc.getWidth() / 2, 140, Graphics.FONT_SMALL, "No segments yet", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth() / 2, 170, Graphics.FONT_XTINY, "Press BACK to return", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        var y_pos = 60;
        var max_items = 5;
        var start_idx = selected_index - 2;
        if (start_idx < 0) {
            start_idx = 0;
        }
        if (start_idx + max_items > segments.size()) {
            start_idx = segments.size() - max_items;
            if (start_idx < 0) { start_idx = 0; }
        }

        for (var i = start_idx; i < start_idx + max_items && i < segments.size(); i++) {
            var seg = segments[i];
            var rating_text = (seg.rating != null) ? seg.rating : "?";
            var item_text = "[" + rating_text + "] " + seg.latitude.format("%.4f");

            if (i == selected_index) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                dc.fillRectangle(0, y_pos - 2, dc.getWidth(), 28);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            } else {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            }

            dc.drawText(8, y_pos, Graphics.FONT_SMALL, item_text, Graphics.TEXT_JUSTIFY_LEFT);
            y_pos += 42;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 295, Graphics.FONT_XTINY, (selected_index + 1) + "/" + segments.size(), Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class ListingsViewDelegate extends WatchUi.BehaviorDelegate {
    private var _view;

    function initialize(listing_view) {
        BehaviorDelegate.initialize();
        _view = listing_view;
    }

    // DOWN — next segment
    function onNextPage() {
        if (_view.selected_index < _view.segments.size() - 1) {
            _view.selected_index++;
            WatchUi.requestUpdate();
        }
        return true;
    }

    // UP — previous segment
    function onPreviousPage() {
        if (_view.selected_index > 0) {
            _view.selected_index--;
            WatchUi.requestUpdate();
        }
        return true;
    }

    // BACK — return to main view
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onKey(keyEvent) {
        return false;
    }
}
