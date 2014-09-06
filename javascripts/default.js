/* Set active links from current path in top nav */
jQuery(function() {
  jQuery('.top-bar-section .left li a:not(.button)').each(function() {
    if (jQuery(this).attr('href')  ===  window.location.pathname) {
      jQuery(this).addClass('active');
    }
  });
});
