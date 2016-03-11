$(function() {
  $('#tag-management').
    on('ajax:success',function(evt, data, status, xhr){
      $("#"+evt.target.dataset.destroy).remove();
    });
  $(".user-profile").each(function(i) {
    $(this).load("/connections/" + i)
  })
  $(".tag_library").each(function(i) {
    $(this).load("/tag_library/0")
  })
  $(".owl-carousel").owlCarousel({
    singleItem: true,
    lazyLoad: true,
    pagination: false
  });
});
