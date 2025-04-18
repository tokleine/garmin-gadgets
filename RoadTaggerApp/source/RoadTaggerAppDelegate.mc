import Toybox.Lang;
import Toybox.WatchUi;

class RoadTaggerAppDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RoadTaggerAppMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}