function spaceFooter()
{
  // Get rid of footer spacing
  $('#footerspacer').height(0);

  // Calculate new footer spacing
  var footerSpacing = $(document).height() - $('body').height();

  // Space footer
  $('#footerspacer').height(footerSpacing);
}

// Space footer now and register resize handler
$(document).on('load page:change', spaceFooter);
$(window).resize(spaceFooter);
