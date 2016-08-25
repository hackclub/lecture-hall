$(document).on('turbolinks:load', () => {
  // Reveal the project submission form when new-project-btn is clicked
  $('.new-project-btn').click(() => {
    $('#project-submission-form').modal('show');
  });

  // Hijack the default submit action
  $('#project-submit-form').submit(event => {
    $('#project-submit').addClass('disabled');
    $('#form-alert-container').html('');

    let showAlert = errMsg => {
      let alertDiv = document.createElement('div');
      let $el = $(alertDiv);
      $el
        .addClass('alert alert-danger')
        .text(errMsg);
      $('#form-alert-container').append($el);
    }

    $.ajax({
      'url': `/projects`,
      'data': {
        'name': $('#name').val(),
        'live_url': $('#live_url').val(),
        'github_url': $('#github_url').val()
      },
      'type': 'POST',
      'success': () => {
        $('#project-submit').addClass('has-success');
        $('#project-submit').val('Success!');
        setTimeout(() => {
          $('#project-submission-form').modal('hide');
          $('#project-submit').removeClass('has-success');
          $('#project-submit').val('Submit');
          $('#name').val('');
          $('#live_url').val('');
          $('#github_url').val('');
        }, 3000);
      },
      'error': e => {
        let errList = JSON.parse(e.responseText).errors;
        if (errList) {
          for (let i = 0; i < errList.length; i++) {
            let errMsg = errList[0];
            showAlert(errMsg);
          }
        } else {
          let errMsg = e.responseText;
          showAlert(errMsg);
        }
      },
      'complete': () => {
        $('#project-submit')
          .removeClass('disabled')
          .blur();
      }
    });

    // Prevent the browser from submitting the form
    return false;
  });
});
