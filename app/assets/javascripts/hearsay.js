$(function() {
  $('#tag-management').
    on('ajax:success',function(evt, data, status, xhr){
      $("#"+evt.target.dataset.destroy).remove();
    });
  $(".user-profile").each(function(i) {
    $(this).load("/connections/" + i)
  })
});
