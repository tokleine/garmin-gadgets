import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Position;
using Toybox.System;
using Toybox.Timer;
import Toybox.Lang;
import Toybox.Math;

class HomeView extends WatchUi.View {

    private var _latitudeElement;
    private var _longitudeElement;
    private var _altitudeElement;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _latitudeElement = findDrawableById("latitude");
        _longitudeElement = findDrawableById("longitude");
        _altitudeElement = findDrawableById("altitude");

        setLatitude(_latitudeElement);
        setLongitude(_longitudeElement);
        setAltitude(_altitudeElement);

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function format_to_6_decimals(number) as Double {
        return number.format("%.6f");
    }

    function setLatitude(latitude) as Void {
        _latitudeElement.setText("Latitude: " + latitude);
        WatchUi.requestUpdate();
    }
    function setLongitude(longitude) as Void {
        _longitudeElement.setText("Longitude: " + longitude);
        WatchUi.requestUpdate();
    }
    function setAltitude(altitude) as Void {
        _altitudeElement.setText("Altitude: " + altitude);
        WatchUi.requestUpdate();
    }
}
