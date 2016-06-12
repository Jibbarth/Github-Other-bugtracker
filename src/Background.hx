package ;

import chrome.Runtime;
import chrome.Tabs;
import com.barth.gob.ElementId;
import com.barth.gob.extend.RuntimeResponse;
import com.barth.gob.Method;
import js.Browser;

class Background {
    static function main():Void{
        new Background();
    }

    public function new():Void{
        if(Browser.getLocalStorage().getItem(ElementId.OPTION_PAGE_VIEW_KEY) == null ||
            Browser.getLocalStorage().getItem(ElementId.BUGTRACKER_URL_KEY) == null ) {
            Runtime.openOptionsPage();
        }
        RuntimeResponse.onMessage.addListener(messageListenerHandler);
    }

    private function messageListenerHandler(?request:Dynamic, sender:MessageSender, ?sendResponse:Dynamic->Void):Void{
        switch (request.method) {
            case Method.GET_BUGTRACKER_URL :
                var bugtrackerIssueUrl:String = Browser.getLocalStorage().getItem(ElementId.BUGTRACKER_URL_KEY);
                sendResponse({url:bugtrackerIssueUrl});
            case Method.SET_BUGTRACKER_URL :
                Browser.getLocalStorage().setItem(ElementId.BUGTRACKER_URL_KEY, request.url);
                sendResponse({success:true});
            case Method.SET_OPTION_PAGE_VIEW:
                Browser.getLocalStorage().setItem(ElementId.OPTION_PAGE_VIEW_KEY, "true");
            default:
                trace('unknow message :'+ request.method);
        }
    }

}
