//= require jquery

$(document).ready( function() {
    $("button").click( function(evt) {
	var action = evt.target.innerHTML;
	var id = $(evt.target.parentNode.parentNode).data("tagId")
	$("#tag_id").val(id);
	$("#moderation_action").val(action);
	$("#moderation_form").submit();
    });
});
