package ;
import chrome.Runtime;
import com.barth.gob.ElementId;
import com.barth.gob.Method;
import com.barth.gob.response.BugtrackerResponse;
import js.Browser;
import js.html.HTMLCollection;
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
        }

        var aCommit:HTMLCollection = Browser.document.getElementsByClassName(ElementId.COMMIT_TITLE);
        if (aCommit.length > 0) {
            trace(aCommit.length + " commits founds");
            parseCommits(aCommit);
        } else {
            trace('no commit found');
        }
    }

    private function getBugtrackerUrlHandler(bugTrackerUrl:BugtrackerResponse):Void {
        trace(bugTrackerUrl.url);
        _bugTrackerIssueUrl = bugTrackerUrl.url;
    }

    private function parseCommits(commits:HTMLCollection):Void {
        for (i in 0 ... commits.length) {
            var mythis = commits[i];
        }
    }
}
