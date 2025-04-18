import Toybox.Lang;
import Toybox.WatchUi;

class HomeDelegate extends WatchUi.BehaviorDelegate {

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
}