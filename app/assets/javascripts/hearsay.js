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
    mobileFirst: true
  });

  $('.tag-carousel').slick({
    arrows: false,
    mobileFirst: true
  });

  $('body').bind('touchmove', function(e){e.preventDefault();});

  setTimeout(function(){
  }, 500);

  $('.users-carousel').on('beforeChange', function(event, slick, currentSlide, nextSlide){
    getConnectionId(nextSlide, didGoLeft(currentSlide, nextSlide));
  });
});

function getConnectionId(slideNum, wentLeft) {
  connectionNum = getConnectionNum(slideNum, wentLeft);
  $.ajax({
    method: 'GET',
    url: '/connections/' + connectionNum
  }).success(function(response) {
    updateContainer(response, connectionNum, slideNum, wentLeft);
  });
}

function getConnectionNum(slideNum, wentLeft) {
  connectionNum = $(".user-profile[data-slick-index='" + slideNum + "'] > .connection-index ").data('connection-index');
  wentLeft ? connectionNum -= 1 : connectionNum += 1;
  return connectionNum;
}

function updateContainer(response, connectionNum, slideNum, wentLeft) {
  leftEdge = (slideNum == 0 && wentLeft) ? true : false;
  rightEdge = (slideNum == 4 && !wentLeft) ? true : false;

  if ( rightEdge ) { updateRightSide(response); }
  if ( leftEdge ) { updateLeftSide(response); }

  wentLeft ? slideNum -= 1 : slideNum += 1;
  updateProfile(response, slideNum);
}

function updateLeftSide(response) {
  updateProfile(response, 4);
}

function updateRightSide(response) {
  updateProfile(response, 0);
}

function updateProfile(response, index) {
  $(".user-profile[data-slick-index='" + index + "']").html(response);
}

function didGoLeft(currentSlide, nextSlide) {
  wentLeft = (currentSlide - nextSlide > 0) ? true : false;

  if (currentSlide - nextSlide == -4) {
    wentLeft = true;
  } else if (currentSlide - nextSlide == 4) {
    wentLeft = false;
  }
  return wentLeft;
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