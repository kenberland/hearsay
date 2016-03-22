$(function() {
  $('#tag-management').
    on('ajax:success',function(evt, data, status, xhr){
      $("#"+evt.target.dataset.destroy).remove();
    });
  $(".user-profile").each(function(i) {
    $(this).load("/connections/" + i)
  })
  $(".tag_library").each(function(i) {
    $(this).load("/tag_library/" + this.dataset.category )
  })
  $(".owl-carousel").owlCarousel({
    items: 1,
    dots: false
  });
  $('body').bind('touchmove', function(e){e.preventDefault()})
});

function addNewTagToCurrentConnection(tagId) {
  var $connection = $('.active-user').data().active_user
  $.ajax({
    method: "POST",
    url: "/users/" + $connection + "/tags",
    data: { tag: { id: tagId } }
  })
    .done(function(response) {
      $newTag = $('<li class="tag-cloud">' + response.new_tag.tag + '</li>'); // have to embed a tag template in the dom
      $("#tags-for-" + response.connection_uid).append($newTag);
      console.dir(response.new_tag);
    });
}

