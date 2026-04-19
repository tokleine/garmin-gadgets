using Toybox.WatchUi;
using Toybox.Graphics;

class RatingView extends WatchUi.View {
    private var segment;
    private var selected_rating = null;

    function initialize(seg) {
        View.initialize();
        segment = seg;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.RatingLayout(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_MEDIUM, "Rate Segment", Graphics.TEXT_JUSTIFY_CENTER);

        var nice_color = (selected_rating == "nice") ? Graphics.COLOR_GREEN : Graphics.COLOR_BLACK;
        var bad_color = (selected_rating == "bad") ? Graphics.COLOR_RED : Graphics.COLOR_BLACK;

        dc.setColor(nice_color, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 4, 150, Graphics.FONT_MEDIUM, "NICE", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(bad_color, Graphics.COLOR_WHITE);
        dc.drawText(3 * dc.getWidth() / 4, 150, Graphics.FONT_MEDIUM, "BAD", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth() / 2, 250, Graphics.FONT_XTINY, "Select with UP/DOWN", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 270, Graphics.FONT_XTINY, "Confirm with ENTER", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class RatingViewDelegate extends WatchUi.InputDelegate {
    private var view;

    function initialize() {
        InputDelegate.initialize();
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            return true;
        } else if (key == WatchUi.KEY_ENTER) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }

        return false;
    }
}
