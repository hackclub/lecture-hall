require 'test_helper'

class WorkshopsControllerTest < ActionDispatch::IntegrationTest
  test 'renders workshops' do
    get '/personal_website'

    assert_response :success

    # The first header in .workshop should say "Personal Website"
    assert_select '.workshop > h1', 'Personal Website'
  end

  test "returns 404 when workshop doesn't exist" do
    assert_raises ActionController::RoutingError do
      get '/invalid_workshop'
    end
  end
end
