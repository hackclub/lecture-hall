window.App = Window.app || {};

// Put any logic that should be run on every page here
App.init = () => {
};

$(document).on('turbolinks:load', () => {
  App.init();
});
