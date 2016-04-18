function updateNextSlide(slideNum, wentLeft, slick) {
  var connectionNum = getConnectionNum(slideNum, wentLeft);
  $.ajax({
    method: 'GET',
    url: '/connections/' + connectionNum
  }).success(function(response) {
    updateContainer(response, connectionNum, slideNum, wentLeft, slick);
  });
}

function filterSlides(slideNum, slick) {
  $('.user-profile').removeClass('filter');
  for(i = 0; i <= slideNum; i++){
    $('#user-profile-' + i).addClass('filter');
  }
  slick.filterSlides('.filter');
  slick.setOption('infinite', false, true);
}

function updateSlideOptions(slick, currentSlide) {
  var currentConnectionNum = getConnectionNum(currentSlide, false, true);
  var nextConnectionNum = getConnectionNum(currentSlide+1, false, true);

  if (currentConnectionNum > nextConnectionNum) { filterSlides(currentSlide, slick); }

  if (currentSlide == 4 || currentSlide == 0) {
    if (currentConnectionNum == 0) {
      slick.setOption('infinite', false, true);
    } else {
      slick.unfilterSlides();
      slick.setOption('infinite', true, true);
    }
  }
}

function getConnectionNum(slideNum, wentLeft, centered) {
  if (centered === undefined) { centered = false; }

  var connectionNum = $(".user-profile[data-slick-index='" + slideNum + "']").find('.connection-index').data('connection-index');
  if (!centered) { wentLeft ? connectionNum -= 1 : connectionNum += 1; }
  return connectionNum;
}

function updateContainer(response, connectionNum, slideNum, wentLeft, slick) {
  var leftEdge = (slideNum == 0 && wentLeft) ? true : false;
  var rightEdge = (slideNum == 4 && !wentLeft) ? true : false;

  if ( rightEdge ) { updateRightSide(response, slick); }
  if ( leftEdge ) { updateLeftSide(response, slick); }

  wentLeft ? slideNum -= 1 : slideNum += 1;
  updateProfile(response, slideNum);
}

function updateLeftSide(response, slick) {
  updateProfile(response, 4);
}

function updateRightSide(response, slick) {
  updateProfile(response, 0);
}

function updateProfile(response, index) {
  $(".user-profile[data-slick-index='" + index + "']").html(response);
}

function didGoLeft(currentSlide, nextSlide) {
  var wentLeft = (currentSlide - nextSlide > 0) ? true : false;

  if (currentSlide - nextSlide == -4) {
    wentLeft = true;
  } else if (currentSlide - nextSlide == 4) {
    wentLeft = false;
  }
  return wentLeft;
}