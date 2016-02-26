/**
 *Background script
 */
const _BUGTRACKER_ISSUE_URL_ = "http://redmine.microclimat.com/issues/"

$('.commit-title').each(function(){
    var mythis = $(this);
    var content = $(this).text();
    var aContent = content.split(/(#[1-9\d-]+)/);
    if(aContent.length > 1) {
        console.log(aContent);
        var oLink = $(this).find('a')[0];
        $(mythis).html('');
        for (var i = 0; i < aContent.length; i++) {
            var newLink = oLink;
            $(newLink).text(aContent[i]);
            $(newLink).clone().appendTo($(mythis));
            newLink = null;
        }
    }
})
