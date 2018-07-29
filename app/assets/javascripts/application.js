// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require_tree .

$(document).on('submit', 'form[method=get][data-turbolinks=true]', function(e) {
  e.preventDefault();
  e.stopImmediatePropagation();
  var form = $(this);
  Turbolinks.visit(form.attr("action") + '?' + form.serialize());
});

$(document).on('click', 'button[data-preview]', function(e) {
  e.preventDefault();
  e.stopImmediatePropagation();
  var button = $(this);
  var form = button.parents('form');
  Turbolinks.visit(button.data('preview') + '?' + form.find('[data-preview]').serialize());
});

$(document).on('input', 'form[data-preview] [data-preview]', function() {
  var form = $(this).parents('form');
  form.find('input[type=submit]').prop('disabled', true);
});
