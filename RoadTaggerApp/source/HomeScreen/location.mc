// using Toybox.Position;


// var options = {
//     :acquisitionType =>; Position.LOCATION_CONTINUOUS
// };

// if (Position has :POSITIONING_MODE_AVIATION) {
//     options[:mode] = Position.POSITIONING_MODE_AVIATION;
// }

// if (Position has :hasConfigurationSupport) {
//     if (Position has :CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1_L5) &&
//        (Position.hasConfigurationSupport(Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1_L5)) {
//         options[:configuration] = Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1_L5;
//     } else if (Position has :CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1) &&
//        (Position.hasConfigurationSupport(Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1)) {
//         options[:configuration] = Position.CONFIGURATION_GPS_GLONASS_GALILEO_BEIDOU_L1;
//     } else if (Position has :CONFIGURATION_GPS) &&
//        (Position.hasConfigurationSupport(Position.CONFIGURATION_GPS)) {
//         options[:configuration] = Position.CONFIGURATION_GPS;
//     }
// } else if (Position has :CONSTELLATION_GLONASS) {
//     // this can fail with InvalidValueException if combination is not supported by device
//     options[:constellations] = [ Position.CONSTELLATION_GPS, Position.CONSTELLATION_GLONASS ];
// } else {
//     options = Position.LOCATION_CONTINUOUS;
// }

// // Continuous location updates using selected options
// Position.enableLocationEvents(options, method(:onPosition));

// function onPosition(info) {
//     var myLocation = info.position.toDegrees();
// }