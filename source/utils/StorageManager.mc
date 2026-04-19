using Toybox.Application;

class StorageManager {
    private static var SEGMENTS_KEY = "segments";

    static function addSegment(segment) {
        var segments = getSegments();
        if (segments == null) {
            segments = [];
        }
        segments.add(segment.toHash());
        saveSegments(segments);
    }

    static function getSegments() {
        var app = Application.getApp();
        var segments_data = app.getProperty(SEGMENTS_KEY);

        if (segments_data == null || segments_data.size() == 0) {
            return [];
        }

        var segments = [];
        for (var i = 0; i < segments_data.size(); i++) {
            segments.add(Segment.fromHash(segments_data[i]));
        }
        return segments;
    }

    static function deleteSegment(index) {
        var segments = getSegments();
        if (index >= 0 && index < segments.size()) {
            var segments_data = [];
            for (var i = 0; i < segments.size(); i++) {
                if (i != index) {
                    segments_data.add(segments[i].toHash());
                }
            }
            saveSegments(segments_data);
        }
    }

    static function clearAllSegments() {
        var app = Application.getApp();
        app.setProperty(SEGMENTS_KEY, []);
    }

    private static function saveSegments(segments) {
        var app = Application.getApp();
        var segments_data = [];
        for (var i = 0; i < segments.size(); i++) {
            if (segments[i] instanceof Segment) {
                segments_data.add(segments[i].toHash());
            } else {
                segments_data.add(segments[i]);
            }
        }
        app.setProperty(SEGMENTS_KEY, segments_data);
    }
}
