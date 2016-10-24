$(window).on('load', function() {

  //Scrolling navigation
  $('.scrolly').scrolly({
      speed: 1000
  });

  $('.navbar-collapse').on('click', function(){
    $(this).collapse('hide');
  });

});
