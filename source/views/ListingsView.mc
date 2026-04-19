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
        dc.drawText(dc.getWidth() / 2, 20, Graphics.FONT_MEDIUM, "Recorded Segments", Graphics.TEXT_JUSTIFY_CENTER);

        if (segments.size() == 0) {
            dc.drawText(dc.getWidth() / 2, 120, Graphics.FONT_MEDIUM, "No segments", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        var y_pos = 60;
        var max_items = 4;
        var start_idx = selected_index - 1;
        if (start_idx < 0) {
            start_idx = 0;
        }

        for (var i = start_idx; i < start_idx + max_items && i < segments.size(); i++) {
            var segment = segments[i];
            var rating_text = (segment.rating != null) ? segment.rating : "?";
            var item_text = "[" + rating_text + "] Lat: " + segment.latitude.format("%.2f");

            if (i == selected_index) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            } else {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            }

            dc.drawText(10, y_pos, Graphics.FONT_SMALL, item_text, Graphics.TEXT_JUSTIFY_LEFT);
            y_pos += 40;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 290, Graphics.FONT_XTINY, "UP/DOWN to navigate, BACK to exit", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class ListingsViewDelegate extends WatchUi.InputDelegate {
    private var _view;

    function initialize(listing_view) {
        InputDelegate.initialize();
        _view = listing_view;
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            if (_view.selected_index > 0) {
                _view.selected_index--;
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            if (_view.selected_index < _view.segments.size() - 1) {
                _view.selected_index++;
                WatchUi.requestUpdate();
            }
            return true;
        } else if (key == WatchUi.KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }

        return false;
    }
}
