import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Position;
using Toybox.System;
using Toybox.Timer;
import Toybox.Lang;

class HomeView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.Home(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) {
        var mockLocation = new Position.Location(
            {
                :latitude => 48.166592793362,
                :longitude => 11.557854449248639,
                :format => :degrees
            }
        );


        // this is the real location data, will use it later
        // var positionInfo = Position.getInfo();

        // var loc = positionInfo.position.toDegrees();
        var loc = mockLocation.toDegrees();
        var mLatitude = format_to_6_decimals(loc[0]);
        var mLongitude = format_to_6_decimals(loc[1]);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,                      // gets the width of the device and divides by 2
            dc.getHeight() / 2,                     // gets the height of the device and divides by 2
            Graphics.FONT_SYSTEM_XTINY,                    // sets the font size
            "Latitude: " + mLatitude + "\n" + "Longitude: " + mLongitude, // sets the text to be displayed
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function format_to_6_decimals(number) as Double {
        return number.format("%.6f");
    }
}
