/**
 *Background script
 */
var _BUGTRACKER_ISSUE_URL_;

$(function(){
    chrome.runtime.sendMessage({method: "getBugtrackerUrl"}, function(response) {
      _BUGTRACKER_ISSUE_URL_ = response.url;
      init();
    });
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
        $('#release_body').on('blur', function(e) {
            var text = $(this).val();
            var aContent = text.split(/(^|[^\[])(#[0-9\d-]+)/);
            console.log(aContent);
            if(aContent.length > 1) {
                $(this).val('');
                var newVal = "";
                for(var i = 0; i<aContent.length; i++) {
                    if(aContent[i].indexOf('#') == 0 && aContent[i].indexOf(' ') < 0) {
                        var ticketNumber = aContent[i].substr(1);
                        var newText = '[' + aContent[i] + ']('+_BUGTRACKER_ISSUE_URL_+ticketNumber+')';
                        newVal += newText;
                    } else {
                        newVal += aContent[i];
                    }
                }
                $(this).val(newVal);
            }
        });
    }
}
