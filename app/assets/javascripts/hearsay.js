//= require hearsay_slick
$(function() {
  $('.user-profile').each(function(i) {
    $(this).load('/connections/' + i, function(response, status, xhr){
      if ( !$('#active-user').data('active_user') ) {
        active_id = $(response).attr('id');
        $('#active-user').data('active_user', active_id);
      }
    });
  });

  $('.tag_library').each(function(i) {
    $(this).load('/tag_library/' + this.dataset.category);
  });

  $('.users-carousel').slick({
    arrows: false,
    mobileFirst: true,
    infinite: false
  });

  $('.tag-carousel').slick({
    arrows: false,
    mobileFirst: true
  });

  $('body').bind('touchmove', function(e){e.preventDefault();});

  $('.users-carousel').on('beforeChange', function(event, slick, currentSlide, nextSlide){
    if (currentSlide != nextSlide) {
      updateNextSlide(nextSlide, didGoLeft(currentSlide, nextSlide), slick);
    }
  });

  $('.users-carousel').on('afterChange', function(event, slick, currentSlide){
    updateSlideOptions(slick, currentSlide);
  });

});

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