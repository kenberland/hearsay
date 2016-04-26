// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require facebook_sdk
//= require toastr.min

toastr.options = {
  "closeButton": true,
  "newestOnTop": true,
  "positionClass": "toast-top-center",
  "hideDuration": "1000",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut",
  "timeOut": "5000",
}
