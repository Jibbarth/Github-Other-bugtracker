package;

import chrome.Runtime;
import com.barth.gob.ElementId;
import com.barth.gob.Method;
import com.barth.gob.response.BugtrackerResponse;
import js.Browser;
import js.html.AnchorElement;
import js.html.InputElement;

class Option {
    private var _bugTrackerIssueUrl:String;
    private var _buttonSaveField:AnchorElement;
    private var _inputUrlField:InputElement;

    static function main():Void{
        new Option();
    }

    public function new() {
        Browser.document.addEventListener('DOMContentLoaded', init);
    }

    private function init():Void{
        _buttonSaveField = cast Browser.document.getElementById(ElementId.OPTION_SAVE_BUTTON);
        _inputUrlField = cast Browser.document.getElementById(ElementId.OPTION_URL_INPUT);
        _buttonSaveField.addEventListener('click', saveUrlHandler);
        if (_bugTrackerIssueUrl == null){
            Runtime.sendMessage({method:Method.GET_BUGTRACKER_URL}, getBugTrackerUrlHandler);
        }
    }

    private function getBugTrackerUrlHandler(bugTrackerUrl:BugtrackerResponse):Void{
        _inputUrlField.value = bugTrackerUrl.url;
        _bugTrackerIssueUrl = bugTrackerUrl.url;
        }

    private function saveUrlHandler():Void{
        Browser.getLocalStorage().setItem(ElementId.BUGTRACKER_URL_KEY, _inputUrlField.value);
        Runtime.sendMessage({"method": Method.SET_BUGTRACKER_URL, "url": _inputUrlField.value}, saveInBackgroundHandler);
    }

    private function saveInBackgroundHandler(response:Dynamic):Void{
        if(response.success) {
            trace("success");
        }
    }
}
