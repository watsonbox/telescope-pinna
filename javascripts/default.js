jQuery(function() {
  /* Set active links from current path in top nav */
  jQuery('.top-bar-section .left li a:not(.button)').each(function() {
    if (jQuery(this).attr('href')  ===  window.location.pathname) {
      jQuery(this).addClass('active');
    }
  });

  /* Support toggling of news items on home page */
  jQuery("[data-behavior~=toggle-news-item]").on("click", function() {
    jQuery(this).closest('p').prevAll(".news-item-body").toggle();

    if (jQuery(this).text() == '+ More') {
      jQuery(this).text('- Less')
    } else {
      jQuery(this).text('+ More')
    }
  })
});
