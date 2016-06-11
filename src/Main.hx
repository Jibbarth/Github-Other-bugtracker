package ;
import chrome.Runtime;
import com.barth.gob.ElementId;
import com.barth.gob.Method;
import com.barth.gob.response.BugtrackerResponse;
import js.Browser;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.TextareaElement;
import js.Lib;

class Main {
    private var _bugTrackerIssueUrl:String;

    static function main():Void{
        new Main();
    }

    public function new() {
        init();
        Browser.document.addEventListener(ElementId.GITHUB_CHANGE_PAGE_EVENT, init);
    }

    private function init() {
        if(_bugTrackerIssueUrl == "" || _bugTrackerIssueUrl == null) {
            Runtime.sendMessage({'method': Method.GET_BUGTRACKER_URL}, getBugtrackerUrlHandler);
        } else {
            var aCommit:HTMLCollection = Browser.document.getElementsByClassName(ElementId.COMMIT_TITLE);
            if (aCommit.length > 0) {
                parseCommits(aCommit);
            }

            var release:TextareaElement = cast Browser.document.getElementById(ElementId.RELEASE_PAGE);
            if(release != null) {
                prepareRelease(release);
            }
        }
    }

    private function getBugtrackerUrlHandler(bugTrackerUrl:BugtrackerResponse):Void {
        _bugTrackerIssueUrl = bugTrackerUrl.url;
        init();
    }

    private function parseCommits(commits:HTMLCollection):Void {
        var regCommitNumber = ~/#([1-9\d-]+)/g;
        for (i in 0 ... commits.length) {
            var content:String = commits[i].innerText;
            commits[i].innerHTML = regCommitNumber.replace(content, '<a href="'+_bugTrackerIssueUrl+'$1" class="issue-link js-issue-link" data-url="'+_bugTrackerIssueUrl+'$1" target="_blank">#$1</a>');
        }
    }

    private function prepareRelease(releaseField:Element):Void {
        if(releaseField.value.length == 0) {
            // TODO
            // This release wasn't exist, we preset ALL
        }
        // TODO
        // Add event listener on blur release field to replace with bugtracker issue url
    }
}
