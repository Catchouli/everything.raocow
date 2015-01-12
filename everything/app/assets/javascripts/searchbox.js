var searchbox = $('#search input');
var defaultSearchValue = $('#search input').val();

searchbox.focus(function()
{
  $(this).val('');
});

searchbox.blur(function()
{
  $(this).val(defaultSearchValue);
});