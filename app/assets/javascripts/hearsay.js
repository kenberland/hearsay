//= require hearsay_slick
$(function() {
  $('.user-profile').each(function(i) {
    $(this).load('/connections/' + i);
  });

  $('.browse-profile').each(function(i) {
    $(this).load('/browse/' + (i+1), function(response, status, xhr){
    });
  });

  $('.tag_library').each(function(i) {
    $(this).load('/tag_library/' + this.dataset.category);
  });

  $('.connection-scroll-container').slick({
    arrows: false,
    mobileFirst: true,
    infinite: false
  });

  $('.tag-carousel').slick({
    arrows: false,
    mobileFirst: true
  });

  $('.connection-scroll-container').on('beforeChange', function(event, slick, currentSlide, nextSlide){
    if (currentSlide != nextSlide) {
      updateNextSlide(nextSlide, didGoLeft(currentSlide, nextSlide), slick);
    }
  });

  $('.connection-scroll-container').on('afterChange', function(event, slick, currentSlide){
    updateSlideOptions(slick, currentSlide);
  });

  $('.modal').on('shown.bs.modal', function () {
    $(this).find('input:text:visible:first').focus();
  });
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
  var connectionId = activeUser().find('.connection').attr('id');
  var connectionIndex = activeUser().find('.connection-index').data('connection-index');
  $.ajax({
    method: "POST",
    url: "/users/" + connectionId + "/tags",
    data: { tag: { id: tagId }, users: { index: connectionIndex } }
  }).done(function(response) {
    $('#tags-for-' + connectionId).replaceWith(response);
  });
}

function deleteNewTagToCurrentConnection(tagId) {
  var connectionId = activeUser().find('.connection').attr('id');
  var connectionIndex = activeUser().find('.connection-index').data('connection-index');
  $.ajax({
    method: "DELETE",
    url: "/users/" + connectionId + "/tags/" + tagId,
    data: { tag: { id: tagId }, users: { index: connectionIndex } }
  }).done(function(response) {
    $('#tags-for-' + connectionId).replaceWith(response);
  });
}

function activeUser(){
  return $('.connection-scroll-container').find('.slick-active');
}
