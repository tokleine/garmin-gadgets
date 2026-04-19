class Segment {
    var latitude;
    var longitude;
    var timestamp;
    var rating;

    function initialize(lat, lon, ts, rating_val) {
        latitude = lat;
        longitude = lon;
        timestamp = ts;
        rating = rating_val;
    }

    function toHash() {
        return {
            "lat" => latitude,
            "lon" => longitude,
            "ts" => timestamp,
            "rating" => rating
        };
    }

    static function fromHash(hash) {
        return new Segment(
            hash["lat"],
            hash["lon"],
            hash["ts"],
            hash["rating"]
        );
    }
}
