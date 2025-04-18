import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class RoadTaggerApp extends Application.AppBase {
    private var _view;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        _view = new HomeView();
        return [ _view, new HomeDelegate() ];
    }

    function getView() as View {
        return _view;
    }

}

function getApp() as RoadTaggerApp {
    return Application.getApp() as RoadTaggerApp;
}

function getView() as HomeView {
    return Application.getApp().getView() as HomeView;
}