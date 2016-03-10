$(function() {
  $('#tag-management').
    on('ajax:success',function(evt, data, status, xhr){
      $("#"+evt.target.dataset.destroy).remove();
    });
  $( ".user-profile" ).load("/users/149359572120482", function() {
  });
});
