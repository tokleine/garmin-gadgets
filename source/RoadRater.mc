using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Position;
using Toybox.Time;

class RoadRater extends Application.AppBase {
    var is_recording = false;
    var recording_start_lat = null;
    var recording_start_lon = null;
    var recording_start_time = null;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function onStop(state) {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function getInitialView() {
        var view = new MainView();
        return [ view, new MainViewDelegate() ];
    }

    function onPosition(info as Position.Info) as Void {
        if (info != null && is_recording && info.accuracy != Position.QUALITY_NOT_AVAILABLE) {
            if (recording_start_lat == null) {
                recording_start_lat = info.position.toDegrees()[0];
                recording_start_lon = info.position.toDegrees()[1];
                recording_start_time = Time.now().value();
            }
        }
    }

    function startRecording() {
        is_recording = true;
        recording_start_lat = null;
        recording_start_lon = null;
        recording_start_time = null;
    }

    function stopRecording() {
        is_recording = false;
        var lat = (recording_start_lat != null) ? recording_start_lat : 0.0;
        var lon = (recording_start_lon != null) ? recording_start_lon : 0.0;
        var ts = (recording_start_time != null) ? recording_start_time : Time.now().value();
        return new Segment(lat, lon, ts, null);
    }

    function getIsRecording() {
        return is_recording;
    }
}
