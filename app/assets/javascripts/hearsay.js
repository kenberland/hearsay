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
