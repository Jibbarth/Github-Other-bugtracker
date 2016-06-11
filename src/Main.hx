package ;
import chrome.Runtime;
import com.barth.gob.Method;
import js.Lib;

class Main {
    private var _bugTrackerUrl:String;

    static function main():Void{
        new Main();
    }

    public function new() {
        Runtime.sendMessage({method: Method.GET_BUGTRACKER_URL}, null, getBugtrackerUrlHandler);
    }

    private function getBugtrackerUrlHandler(bugTrackerUrl:String):Void {
        trace(bugTrackerUrl);
        _bugTrackerUrl = bugTrackerUrl;
    }
}
