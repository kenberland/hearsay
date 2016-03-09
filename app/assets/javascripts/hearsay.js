$(function() {
  $('#tag-management').
    on('ajax:success',function(evt, data, status, xhr){
      $("#"+evt.target.dataset.destroy).remove();
    });
});
