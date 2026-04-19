using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Position;

class RoadRater extends Application.AppBase {
    var is_recording = false;
    var recording_start_lat = null;
    var recording_start_lon = null;
    var recording_start_time = null;
    var gps_enabled = false;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        if (Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition))) {
            gps_enabled = true;
        }
    }

    function onStop(state) {
        if (gps_enabled) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, null);
        }
    }

    function getInitialView() {
        return [ new MainView() ];
    }

    function onPosition(info) {
        if (info != null && is_recording) {
            if (recording_start_lat == null) {
                recording_start_lat = info.latitude;
                recording_start_lon = info.longitude;
                recording_start_time = System.getClockTime().value;
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
        if (recording_start_lat != null && recording_start_lon != null) {
            return new Segment(recording_start_lat, recording_start_lon, System.getClockTime().value, null);
        }
        return null;
    }

    function getIsRecording() {
        return is_recording;
    }
}
