using Toybox.Application.Storage;

class StorageManager {
    private static var SEGMENTS_KEY = "segments";

    static function addSegment(segment) {
        var segments_data = Storage.getValue(SEGMENTS_KEY);
        if (segments_data == null) {
            segments_data = [];
        }
        segments_data.add(segment.toHash());
        Storage.setValue(SEGMENTS_KEY, segments_data);
    }

    static function getSegments() {
        var segments_data = Storage.getValue(SEGMENTS_KEY);
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
        var segments_data = Storage.getValue(SEGMENTS_KEY);
        if (segments_data == null) {
            return;
        }
        if (index >= 0 && index < segments_data.size()) {
            segments_data.remove(segments_data[index]);
            Storage.setValue(SEGMENTS_KEY, segments_data);
        }
    }

    static function clearAllSegments() {
        Storage.setValue(SEGMENTS_KEY, []);
    }
}
