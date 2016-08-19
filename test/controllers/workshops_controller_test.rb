require 'test_helper'

class WorkshopsControllerTest < ActionDispatch::IntegrationTest
  test 'renders readme on index' do
    get '/'

    # The first header should say "Workshop"
    assert_select '.workshop-contents > h1', 'Workshops'

    # It should have a sidebar
    assert_select '.workshop-sidebar > ul > li > a'
  end

  test 'title on index' do
    get '/'

    assert_select 'title', 'Hack Club Workshops'
  end

  test 'shows workshops' do
    get '/personal_website/'

    # The first header in .workshop should say "Personal Website"
    assert_select '.workshop-contents > h1', 'Personal Website'

    # There should be a sidebar
    assert_select '.workshop-sidebar > ul > li > a'
  end

  test 'workshop titles' do
    get '/personal_website/'

    assert_select 'title', 'Personal Website | Hack Club Workshops'
  end

  test 'passes correct page tracking metadata' do
    # view the workshop without signing in
    get '/personal_website/'

    expected = nil
    actual = @controller.instance_variable_get(:@metadata_should_not_track_page)

    assert_equal expected, actual

    # sign in and view the workshop
    get '/auth/github/callback'
    get '/personal_website/'

    expected = true
    actual = @controller.instance_variable_get(:@metadata_should_not_track_page)

    assert_equal expected, actual
  end

  test 'redirects workshops when no trailing slash' do
    get '/personal_website'

    assert_redirected_to '/personal_website/'
  end

  test 'redirects workshops when requesting README.md' do
    get '/personal_website/README.md'

    assert_redirected_to '/personal_website/'
  end

  test "returns 404 when workshop doesn't exist" do
    assert_raises ActionController::RoutingError do
      get '/invalid_workshop/'
    end
  end

  test 'retrieves regular file from workshop' do
    get '/personal_website/img/final_screenshot.png'

    assert_equal 'image/png', response.content_type
  end

  test 'renders markdown files from workshops' do
    get '/personal_website/'

    assert_select '.workshop-contents > h1', 'Personal Website'
  end

  test 'title with markdown files in workshops' do
    get '/personal_website/'

    assert_select 'title', 'Personal Website | Hack Club Workshops'
  end

  test "returns 404 when regular file doesn't exist" do
    assert_raises ActionController::RoutingError do
      get '/personal_website/fake_file.png'
    end
  end

  test "returns 404 when markdown file doesn't exist" do
    assert_raises ActionController::RoutingError do
      get '/personal_website/FAKE.md'
    end
  end

  test "the proper page event is sent when workshop roots are loaded" do
    get '/auth/github/callback'
    get '/personal_website/'

    assert_has_tracked_page_view('Personal Website')
  end

  test "no page event is sent when markdown files are loaded" do
    get '/auth/github/callback'
    get '/personal_website/README.md'

    assert_has_not_tracked_page_view('Personal Website')
  end
end
