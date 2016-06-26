package;

import chrome.Runtime;
import com.barth.gob.ElementId;
import com.barth.gob.Method;
import com.barth.gob.response.BugtrackerResponse;
import js.Browser;
import js.html.ButtonElement;
import js.html.InputElement;
import haxe.Json;
import jQuery.JQuery;

class Option {
    private var _bugTrackerIssueUrl:String;
    private var _buttonSaveField:ButtonElement;
    private var _inputUrlField:InputElement;
    private var _checkboxUseRelease:InputElement;

    static function main():Void{
        new Option();
    }

    public function new() {
        Browser.document.addEventListener('DOMContentLoaded', init);
    }

    private function init():Void{
        Runtime.sendMessage({method:Method.SET_OPTION_PAGE_VIEW});
        _buttonSaveField = cast Browser.document.getElementById(ElementId.OPTION_SAVE_BUTTON);
        _inputUrlField = cast Browser.document.getElementById(ElementId.OPTION_URL_INPUT);
        _checkboxUseRelease = cast Browser.document.getElementById(ElementId.OPTION_USE_RELEASE_CB);

        // Get use release
        Runtime.sendMessage({method:Method.GET_USE_RELEASE}, getUseReleaseHandler);

        _buttonSaveField.addEventListener('click', saveFormHandler);
        if (_bugTrackerIssueUrl == null){
            Runtime.sendMessage({method:Method.GET_BUGTRACKER_URL}, getBugTrackerUrlHandler);
        }
    }

    private function saveFormHandler():Void{
        saveUrlHandler();
        Browser.getLocalStorage().setItem(ElementId.USE_RELEASE_KEY, cast _checkboxUseRelease.checked);
        Runtime.sendMessage({"method": Method.SET_USE_RELEASE, "url": cast _checkboxUseRelease.checked}, saveInBackgroundHandler);
        Runtime.sendMessage({method:Method.OPTION_CHANGED});
    }

    private function getBugTrackerUrlHandler(bugTrackerUrl:BugtrackerResponse):Void{
        _inputUrlField.value = bugTrackerUrl.url;
        _bugTrackerIssueUrl = bugTrackerUrl.url;
    }

    private function getUseReleaseHandler(response:Dynamic):Void{
        _checkboxUseRelease.checked = Json.parse(response.checked);
    }

    private function saveUrlHandler():Void{
        Browser.getLocalStorage().setItem(ElementId.BUGTRACKER_URL_KEY, _inputUrlField.value);
        Runtime.sendMessage({"method": Method.SET_BUGTRACKER_URL, "url": _inputUrlField.value}, saveInBackgroundHandler);
    }

    private function saveInBackgroundHandler(response:Dynamic):Void{
        if(response.success) {
            new JQuery('#'+ElementId.OPTION_SAVE_BUTTON).find('i').hide().removeClass('hidden').fadeIn();
            haxe.Timer.delay(function() {
                new JQuery('#'+ElementId.OPTION_SAVE_BUTTON).find('i').fadeOut();
            }, 1500);
        }
    }
}
