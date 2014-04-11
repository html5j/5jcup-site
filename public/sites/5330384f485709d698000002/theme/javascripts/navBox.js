jQuery(function($) {
  
var nav    = $('#navBox'),
    offset = nav.offset();
  
$(window).scroll(function () {
  if($(window).scrollTop() > 300) {
    nav.addClass('fixed');
  } else {
    nav.removeClass('fixed');
  }
});
  
});
