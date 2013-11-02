//= require jquery

$('form table :input').on('change', function(e) {
  $(e.target).closest('form').submit();
});
