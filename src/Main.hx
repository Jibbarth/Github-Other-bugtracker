package;

import chrome.Runtime;
import chrome.Tabs;
import com.barth.gob.ElementId;
import com.barth.gob.Method;
import com.barth.gob.Message;
import com.barth.gob.response.BugtrackerResponse;
import com.barth.gob.CommitList;
import com.barth.gob.Comment;
import js.Browser;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.InputElement;
import js.html.TextAreaElement;
import haxe.Json;

class Main
{
    private var _bugTrackerIssueUrl:String;
    private var _useReleaseFeature:Bool;
    private var _releaseExist:Bool;
    private var _commitList:CommitList;
    private var _commentUtil:Comment;

    static function main():Void{
        new Main();
    }

    public function new() {
        updateSettings();
        _commitList = new CommitList();
        _commentUtil = new Comment();
        Runtime.onMessage.addListener(messageListenerHandler);
        init();
        Browser.document.addEventListener(ElementId.GITHUB_CHANGE_PAGE_EVENT, init);
    }

    private function init() {
        if (_useReleaseFeature == null) {
            Runtime.sendMessage({'method': Method.GET_USE_RELEASE}, getUseReleaseHandler);
        }

        if (_bugTrackerIssueUrl == null) {
            Runtime.sendMessage({'method': Method.GET_BUGTRACKER_URL}, getBugtrackerUrlHandler);
        } else {
            var commitList:HTMLCollection = Browser.document.getElementsByClassName(ElementId.COMMIT_TITLE);
            if (commitList.length > 0) {
                _commitList.parseCommits(commitList);
            }
        }
        var release:TextAreaElement = cast Browser.document.getElementById(ElementId.RELEASE_PAGE);
        if (release != null) {
            if (_releaseExist == null) {
                _releaseExist = false;
                if (release.value.length > 0) {
                    _releaseExist = true;
                }
            }
            prepareRelease(release);
        }

        var pullRequest:TextAreaElement = cast Browser.document.getElementById(ElementId.PULL_REQUEST_BODY);
        if (pullRequest != null) {
            Runtime.sendMessage({'method': Method.SPEAK, 'message': Message.NEW_PULL_REQUEST});
        }
    }

    private function getBugtrackerUrlHandler(bugTrackerUrl:BugtrackerResponse):Void {
        _bugTrackerIssueUrl = bugTrackerUrl.url;
        _commitList.setBugTrackerUrl(_bugTrackerIssueUrl);
        _commentUtil.setBugTrackerUrl(_bugTrackerIssueUrl);
        init();
    }

    private function getUseReleaseHandler(response:Dynamic):Void {
        _useReleaseFeature = Json.parse(response.checked);
    }

    private function prepareRelease(releaseField:TextAreaElement):Void {
        Runtime.sendMessage({'method': Method.SPEAK, 'message': Message.NEW_RELEASE});
        var releaseNumber:InputElement = cast Browser.document.getElementById(ElementId.RELEASE_TAG_NAME);

        releaseNumber.addEventListener('change', function(){
            prepareRelease(releaseField);
        });

        if (_releaseExist == false && _useReleaseFeature && releaseNumber.value != "") {
            // This release wasn't exist, we preset ALL
            var allVersion:HTMLCollection = cast Browser.document.getElementById(ElementId.TAG_LIST).getElementsByTagName('option');
            var sPreviousNumber:String = "#TO_REPLACE#";
            for (i in 0 ... allVersion.length) {
                if (allVersion[i].innerText == releaseNumber.value && (i+1) < allVersion.length) {
                    sPreviousNumber = allVersion[i+1].innerText;
                    break;
                }
            }

            var aPath = cast Browser.location.pathname.split('/');
            var repoPath = [aPath[0], aPath[1], aPath[2]];
            var urlChangelog:String = repoPath.join('/') + '/compare/' + sPreviousNumber + '...'+releaseNumber.value;

            var releaseNameField:InputElement = cast Browser.document.getElementById(ElementId.RELEASE_NAME);
            releaseNameField.value = "["+aPath[2]+"] Release " + releaseNumber.value;

            var descRelease:String =  "# Release " + releaseNumber.value;
            descRelease += "\n\n**New Features :**\n- ... ";
            descRelease += "\n\n**Fix :**\n- ... ";
            descRelease += "\n\n**Improvement :**\n- ... ";
            descRelease += "\n\n[Changelog](https://github.com"+urlChangelog+") ";
            releaseField.value = descRelease;
        }

        // Add event listener on blur release field to replace with bugtracker issue url
        if (_bugTrackerIssueUrl != "") {
            releaseField.addEventListener('blur', leaveReleaseDescHandler);
        }
    }

    private function leaveReleaseDescHandler():Void{
        var release:TextAreaElement = cast Browser.document.getElementById(ElementId.RELEASE_PAGE);

        release.value = _commentUtil.getContentWithCommitLink(release.value);
    }

    private function updateSettings():Void{
        Runtime.sendMessage({'method': Method.GET_USE_RELEASE}, getUseReleaseHandler);
        Runtime.sendMessage({'method': Method.GET_BUGTRACKER_URL}, getBugtrackerUrlHandler);
    }

    private function messageListenerHandler(?request:Dynamic, sender:MessageSender, ?sendResponse:Void->Void):Void{
        switch (request.method) {
            case Method.OPTION_CHANGED:
                updateSettings();
                sendResponse();
            default:
                trace('Unknow method ' + request.method);
        }
    }

}
