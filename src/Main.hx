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
        } else {
            var aCommit:HTMLCollection = Browser.document.getElementsByClassName(ElementId.COMMIT_TITLE);
            if (aCommit.length > 0) {
                parseCommits(aCommit);
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
}
