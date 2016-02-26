/**
 *Background script
 */
const _BUGTRACKER_ISSUE_URL_ = "http://redmine.microclimat.com/issues/"

$('.commit-title').each(function(){
    var content = $(this).text();
    var aContent = content.split(/(#[1-9\d-]+)/);
    if(aContent.length > 1) {
        console.log(aContent);
        var oLink = $(this).find('a');
        $(this).html();
        for (var i = 0; i < aContent.length; i++) {
            oLink.text(aContent[i]);
            $(this).append(oLink);
        }
    }
})
