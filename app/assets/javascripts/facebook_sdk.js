$(document).ready(function() {
  checkLoginState = function() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }
  function statusChangeCallback(response) {
    if (response.status === 'connected') {
      setFBStatus();
    } else if (response.status === 'not_authorized') {
      $('.status').html('Please log into this app.');
    } else {
      $('.status').html('Please log into Facebook.');
    }
  }
  function setFBStatus() {
    FB.api('/me', function(response) {
      $('.status').html('Thanks for logging in, ' + response.name + '!');
    });
  }
  function hideFBLoginButton() {
    $('.login-button').hide();
  }

  $.ajaxSetup({ cache: true });
  $.getScript('//connect.facebook.net/en_US/sdk.js', function(){
    FB.init({
      appId: '243930149277449',
      version: 'v2.5',
      cookie : true,
      xfbml  : true
    });
    $('#loginbutton,#feedbutton').removeAttr('disabled');

    // redirect after login
    FB.Event.subscribe('auth.login', function () {
      $.getJSON('/auth/facebook/callback', function(json) {
	$(location).attr('href', json.location);
      });
    });

    FB.getLoginStatus(statusChangeCallback);
  });


(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5&appId=243930149277449";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
});

