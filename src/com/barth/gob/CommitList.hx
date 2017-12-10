package com.barth.gob;

import chrome.Runtime;
import com.barth.gob.response.BugtrackerResponse;
import com.barth.gob.Method;
import com.barth.gob.ElementId;
import js.html.AnchorElement;
import js.html.HTMLCollection;
import StringTools;

class CommitList
{
    private var _bugTrackerIssueUrl:String;
    private var regCommitNumber:EReg = ~/#([1-9\d-]+)/g;

    public function new() {
        Runtime.sendMessage({'method': Method.GET_BUGTRACKER_URL}, getBugtrackerUrlHandler);
    }

    public function parseCommits(commits:HTMLCollection) {
        for (i in 0 ... commits.length) {
            var anchorElements:HTMLCollection = cast commits[i].getElementsByTagName('a');
            var linksLength:Int = anchorElements.length;

            if (linksLength >= 1) {
                for (j in 0 ... linksLength) {
                    var originalAnchor:AnchorElement = cast anchorElements[j];
                    replaceCommitForAnchor(originalAnchor);
                }
            } else {
                var content:String = commits[i].innerText;
                commits[i].innerHTML = regCommitNumber.replace(content, '<a href="'+_bugTrackerIssueUrl+'$1" class="issue-link js-issue-link" data-url="'+_bugTrackerIssueUrl+'$1" target="_blank">#$1</a>');
            }
        }
    }

    public function setBugTrackerUrl(bugTrackerUrl:String):Void{
        _bugTrackerIssueUrl = bugTrackerUrl;
    }

    private function getBugtrackerUrlHandler(bugTrackerUrl:BugtrackerResponse):Void {
        _bugTrackerIssueUrl = bugTrackerUrl.url;
    }

    private function replaceCommitForAnchor(elem:AnchorElement):Void {
        if (elem.className.indexOf(ElementId.ISSUE_LINK_CLASS) < 0){
            var content = elem.innerText;
            elem.title = "";
            var output:String = regCommitNumber.replace(content, '</a><a href="'+_bugTrackerIssueUrl+'$1" class="issue-link js-issue-link" data-url="'+_bugTrackerIssueUrl+'$1" target="_blank">#$1</a><a href="'+elem.href+'">');
            elem.outerHTML = StringTools.replace(elem.outerHTML, content, output);
            elem.title = content;
        }
    }
}
