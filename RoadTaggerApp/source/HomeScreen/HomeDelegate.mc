import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Position;

class HomeDelegate extends WatchUi.BehaviorDelegate {

    private var recording_status = Recording.paused;
    private var _timer;
    private var _currentDuration = 0;

    private var _view = getView();

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        // WatchUi.pushView(new Rez.Menus.MainMenu(), new RoadTaggerAppMenuDelegate(), WatchUi.SLIDE_UP);
        System.println("Menu action triggered");
        return true;
    }

    function onNextPage() as Boolean {
        System.println("Next page action triggered");
        return true;
    }

    function onSelect() as Boolean {
        // if (recording_status == Recording.started) {
        //     // Stop recording
        //     System.println("Paused recording");
        //     recording_status = Recording.paused;
        // } else 
        if (recording_status == Recording.paused) {
            // Start recording
            System.println("Started recording");
            recording_status = Recording.started;
            startCountdown();
        }
        return true;
    }

    function startCountdown() {
        _currentDuration = 20;
        _timer = new Timer.Timer();
        _timer.start(method(:updateTimer), 1000, true);
    }

    function updateTimer() as Void {
        if (_currentDuration == 0) {
            _timer.stop();
            System.println("Timer finished");
        }

        var mockLocation = new Position.Location(
            {
                :latitude => getRandomLatitude(),
                :longitude => getRandomLongitude(),
                :altitude => 0.0,
                :format => :degrees
            }
        );
        var loc = mockLocation.toDegrees();
        // var mLatitude = format_to_6_decimals(loc[0]);
        // var mLongitude = format_to_6_decimals(loc[1]);

        _view.setLatitude(loc[0]);
        _view.setLongitude(loc[1]);
        _currentDuration--;
        System.println("Current duration: " + _currentDuration);
    }

        // Generate a random float between -90 and 90
    function getRandomLatitude() {
        // Get random integer from 0 to 2^31-1
        var randomInt = Math.rand();
        
        // Convert to float between 0.0 and 1.0
        var normalized = randomInt / 2147483647.0;
        
        // Scale to range -90 to 90 (total range of 180)
        var latitude = (normalized * 180.0) - 90.0;
        
        return latitude;
    }

    // Generate a random float between -180 and 180
    function getRandomLongitude() {
        // Get random integer from 0 to 2^31-1
        var randomInt = Math.rand();
        
        // Convert to float between 0.0 and 1.0
        var normalized = randomInt / 2147483647.0;
        
        // Scale to range -180 to 180 (total range of 360)
        var longitude = (normalized * 360.0) - 180.0;
        
        return longitude;
    }
}