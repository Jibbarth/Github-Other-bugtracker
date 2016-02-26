chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    switch(request.method) {
        case "getBugtrackerUrl":
            sendResponse({url: localStorage.bugtracker_issue_url});
            break;
        case "setBugtrackerUrl":
            localStorage.bugtracker_issue_url = request.url;
            sendResponse({}); // snub them.
            break;
        default:
            sendResponse({}); // snub them.
            break;
    }
});
