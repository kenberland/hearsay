//= require hearsay_slick
$(function() {
  $('.user-profile').each(function(i) {
    $(this).load('/connections/' + i, function(response, status, xhr){
      if ( !$('#active-user').data('active-user') ) {
        var active_id = $(response).siblings('.connection').attr('id');
        var active_index = $(response).siblings('.connection-index').data('connection-index');
        $('#active-user').data('active-user', active_id);
        $('#active-user').data('active-index', active_index);
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

  $('.modal').on('shown.bs.modal', function () {
    $(this).find('input:text:visible:first').focus();
  })
});

function addNewTag() {
  var category = $('.slick-current.tag_library').data('category');
  var tag = $('.new-tag').val();
  $.ajax({
    method: "POST",
    url: "/tag_library/" + category + "/create",
    data: { tag: tag }
  }).done(function(response) {
    $('.new-tag').val('');
    $('#tag-library-' + category).find('div#tag-management').replaceWith(response);
  });
}

function addNewTagToCurrentConnection(tagId) {
  var connection = $('#active-user').data('active-user');
  var connectionIndex = $('#active-user').data('active-index');
  $.ajax({
    method: "POST",
    url: "/users/" + connection + "/tags",
    data: { tag: { id: tagId }, users: { index: connectionIndex } }
  }).done(function(response) {
    $('#tags-for-' + connection).replaceWith(response);
  });
}

function deleteNewTagToCurrentConnection(tagId) {
  var connection = $('#active-user').data('active-user');
  var connectionIndex = $('#active-user').data('active-index');
  $.ajax({
    method: "DELETE",
    url: "/users/" + connection + "/tags/" + tagId,
    data: { tag: { id: tagId }, users: { index: connectionIndex } }
  }).done(function(response) {
    $('#tags-for-' + connection).replaceWith(response);
  });
}
