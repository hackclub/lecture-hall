// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', () => {
  let scrollSpy = new AppScrollSpy(
    $('body'),
    '.workshop-sidebar'
  );

  scrollSpy.init();
});
