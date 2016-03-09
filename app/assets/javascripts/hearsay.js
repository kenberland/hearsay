$(function() {
  $('#tag-management').
    on('ajax:success',function(evt, data, status, xhr){
      console.dir(evt.target);
      //$(this).remove();
    });
});
