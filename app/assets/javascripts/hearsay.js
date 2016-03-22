$(function() {
  $(".user-profile").each(function(i) {
    $(this).load("/connections/" + i, function(response, status, xhr){
      if ( !$('#active-user').data('active_user') ) {
        active_id = $(response).attr('id');
        $('#active-user').data('active_user', active_id);
      }
    });
  });

  $(".tag_library").each(function(i) {
    $(this).load("/tag_library/" + this.dataset.category);
  });

  $(".owl-carousel").owlCarousel({
    items: 1,
    dots: false,
    onDragged: owlCallback
  });

  $('body').bind('touchmove', function(e){e.preventDefault();});
});

function owlCallback(event){
  var eventName = event.type;

  if ( eventName == 'dragged' ) {
    active_id = $('.owl-item.active > .user-profile > .row').attr('id');
    $('#active-user').data('active_user', active_id);
  }
};

function addNewTagToCurrentConnection(tagId) {
  var $connection = $('#active-user').data('active_user');
  $.ajax({
    method: "POST",
    url: "/users/" + $connection + "/tags",
    data: { tag: { id: tagId } }
  })
    .done(function(response) {
      $('#tags-for-' + $connection).replaceWith(response);
    });
}

function deleteNewTagToCurrentConnection(tagId) {
  var $connection = $('#active-user').data('active_user');
  $.ajax({
    method: "DELETE",
    url: "/users/" + $connection + "/tags/" + tagId,
    data: { tag: { id: tagId } }
  })
    .done(function(response) {
      $('#tags-for-' + $connection).replaceWith(response);
    });
}
