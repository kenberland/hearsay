$(function() {
  $('.user-profile').each(function(i) {
    $(this).load('/connections/' + i, function(response, status, xhr){
      if ( !$('#active-user').data('active_user') ) {
        active_id = $(response).attr('id');
        $('#active-user').data('active_user', active_id);
      }
    });
  });

  $('.tag_library').each(function(i) {
    $(this).load('/tag_library/' + this.dataset.category);
  });

  $('.users-carousel').slick({
    arrows: false,
    mobileFirst: true,
    initialSlide: 2
  });

  $('.tag-carousel').slick({
    arrows: false,
    mobileFirst: true
  });

  $('body').bind('touchmove', function(e){e.preventDefault();});

  setTimeout(function(){
    $('.users-carousel').slick('refresh');
  }, 500);

  $('.users-carousel').on('beforeChange', function(event, slick, currentSlide, nextSlide){
    wentLeft = false;
    edge = false;

    if ( currentSlide - nextSlide < 0 || currentSlide - nextSlide == 4 ) { wentLeft = true; }
    if ( nextSlide - 1 == 0 && !wentLeft ) { edge = 'right'; }
    if ( nextSlide + 1 == 4 && wentLeft ) { edge = 'left'; }

    console.log(edge);
    getConnectionId(nextSlide, wentLeft, edge);
  });
});

function getConnectionId(slideNum, wentLeft, edge) {
  // Not gonna stay as slideNum.  Gotta figure out the connection# and then do the math still
  wentLeft ? slideNum += 2 : slideNum -= 2;
  $.ajax({
    method: 'GET',
    url: '/connections/' + slideNum
  }).success(function(response) {
    updateContainer(response, wentLeft, slideNum, edge);
  });
}

function updateContainer(response, wentLeft, slideNum, edge) {
  left = wentLeft;
  right = !wentLeft;

  if ( right ) { slideNum -= 1; }
  if ( left ) { slideNum += 1; }

  if ( edge == 'left' ) { updateLTREdgeContainer(response); }
  if ( edge == 'right' ) { updateRTLEdgeContainer(response); }

//  $(".user-profile[data-slick-index='" + slideNum + "']").html(response);
}

function addNewTagToCurrentConnection(tagId) {
  var $connection = $('#active-user').data('active_user');
  $.ajax({
    method: "POST",
    url: "/users/" + $connection + "/tags",
    data: { tag: { id: tagId } }
  })
    .done(function(response) {
      $('#tags-for-' + $connection).replaceWith(response);
    });
}

function deleteNewTagToCurrentConnection(tagId) {
  var $connection = $('#active-user').data('active_user');
  $.ajax({
    method: "DELETE",
    url: "/users/" + $connection + "/tags/" + tagId,
    data: { tag: { id: tagId } }
  })
    .done(function(response) {
      $('#tags-for-' + $connection).replaceWith(response);
    });
}

function updateLTREdgeContainer(response) {
  $(".user-profile[data-slick-index='0']").html(response);
  $(".user-profile[data-slick-index='5']").html(response);
}

function updateRTLEdgeContainer(response) {
  $(".user-profile[data-slick-index='-1']").html(response);
  $(".user-profile[data-slick-index='4']").html(response);
}