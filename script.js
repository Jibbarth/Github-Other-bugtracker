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
        if($('#release_body').length > 0) {
            //get release number
            if($('#release_body').val().length == 0) {
                var sReleaseNumber = $('#release_tag_name').val();
                var allVersion = $('#git-tags').find('option');
                var sPreviousNumber = "#TO_REPLACE#";
                for (var i = 0; i < allVersion.length; i++) {
                    if($(allVersion[i]).html() == sReleaseNumber && (i+1) < allVersion.length) {
                        sPreviousNumber = $(allVersion[i+1]).html();
                        break;
                    }
                }
                var aPath = window.location.pathname.split('/');
                var repoPath = [aPath[0], aPath[1], aPath[2]];
                var sUrlChangelog = repoPath.join('/')+'/compare/'+sPreviousNumber+'...'+sReleaseNumber;
                var sRelease = "# Release " + sReleaseNumber ;
                $('#release_name').val('['+aPath[2]+'] Release ' +sReleaseNumber);
                sRelease += "\n\n**News Features :**\n- ... ";
                sRelease += "\n\n**Fix :**\n- ... ";
                sRelease += "\n\n**Improvement :**\n- ... ";
                sRelease += "\n\n [Changelog](https://github.com"+sUrlChangelog+") ";
                $('#release_body').val(sRelease);
            }

        }
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
