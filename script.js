/**
 *Background script
 */
var _BUGTRACKER_ISSUE_URL_;

chrome.runtime.sendMessage({method: "getBugtrackerUrl"}, function(response) {
  _BUGTRACKER_ISSUE_URL_ = response.url;
  init();
});


/**
 * Browse all commit-title
 * and do replacement
 */
function init(){
    if(_BUGTRACKER_ISSUE_URL_ != null) {
        $('.commit-title').each(function(){
            var mythis = $(this);
            var content = $(this).text();
            var aContent = content.split(/(#[1-9\d-]+)/);
            if(aContent.length > 1) {
                console.log(aContent);
                var oLink = $(this).find('a')[0];
                $(mythis).html('');
                for (var i = 0; i < aContent.length; i++) {
                    if(aContent[i].indexOf('#') == 0) {
                        var ticketNumber = aContent[i].substr(1);
                        var newUrl = _BUGTRACKER_ISSUE_URL_ + ticketNumber;
                        var aElement = '<a href="'+newUrl+'" class="issue-link js-issue-link" data-url="'+newUrl+'" target="_blank">'+aContent[i]+'</a>';
                        $(mythis).append($(aElement));
                    } else {
                        var newLink = oLink;
                        $(newLink).text(aContent[i]);
                        $(newLink).clone().appendTo($(mythis));
                        newLink = null;
                    }
                }
            }
        });
    }
}
