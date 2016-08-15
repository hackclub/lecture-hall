// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', () => {
  let scrollSpy = new AppScrollSpy(
    $('body'),
    '.workshop-sidebar'
  );

  scrollSpy.init();

  // Clicking project submit buttons trigger project submit modal
  $('.project-submit-btn').click(() => {
    $('#project-submission-form').modal('show');
  })

  // Validate input and add bootstrap success or danger classes

  // Usage examples:
  // $('input').validate()
  (($ => {
    $.fn.validate = function() {
      let validations = {
        // Check that a GitHub url is valid
        'validate-github-url': (url) => {
          $.get('/projects/validate_github_repository_url?url=' + url, function(response) {
            return response.valid;
          })
          return true
        }
      }
      this.filter('input[class*=validate-]').each(function() {
        $(this).addClass('cake')
        let val = this.value;
        let classes = this.className.split(' ');
        let isValid = this

        for (let htmlClass of classes) {
          if (validations.hasOwnProperty(htmlClass)) {
            let result = validations[htmlClass](val);
            isValid = isValid && result;
          }
        }

        if (isValid) {
          $(this).parent().addClass('has-success');
          $(this).parent().removeClass('has-warning has-danger');
        } else {
          $(this).parent().addClass('has-danger');
          $(this).parent().removeClass('has-success has-warning');
        }
      })
    };
  })(jQuery));
});
