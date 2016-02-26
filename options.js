
$(document).ready(function(){
	$('#saveBtn').on("click", function(){
		save();
	})
	chrome.runtime.sendMessage({method: "getBugtrackerUrl"}, function(response) {
	  $('#bugtracker_issue_url').val(response.url);
	});
});

function save(){
	localStorage.bugtracker_issue_url = $('bugtracker_issue_url').val();
	chrome.runtime.sendMessage({method: 'setBugtrackerUrl', url:$('#bugtracker_issue_url').val()});
}
