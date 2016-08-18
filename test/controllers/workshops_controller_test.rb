require "test_helper"

class WorkshopsControllerTest < ActionDispatch::IntegrationTest
  test "renders readme on index" do
    get "/"

    # The first header should say "Workshop"
    assert_select ".workshop-contents > h1", "Workshops"

    # It should have a sidebar
    assert_select ".workshop-sidebar > ul > li > a"
  end

  test "title on index" do
    get "/"

    assert_select "title", "Hack Club Workshops"
  end

  test "renders markdown files in root" do
    get "/CONTRIBUTING.md"

    # The page title should include file name and "Hack Club Workshops"
    assert_select "title", "CONTRIBUTING.md | Hack Club Workshops"

    # There should be a sidebar
    assert_select ".workshop-sidebar > ul > li > a"
  end

  test "serves non-markdown files from root" do
    path = Rails.root.join("vendor", "hackclub", "workshops", "test.txt")
    FileUtils.touch(path)
    get "/test.txt"
    FileUtils.rm(path)
    assert_response :success
  end

  test "serves files without extensions from root" do
    path = Rails.root.join("vendor", "hackclub", "workshops", "test")
    FileUtils.touch(path)
    get "/test"
    FileUtils.rm(path)
    assert_response :success
  end

  test "shows workshops" do
    get "/personal_website/"

    # The first header in .workshop should say "Personal Website"
    assert_select ".workshop-contents > h1", "Personal Website"

    # There should be a sidebar
    assert_select ".workshop-sidebar > ul > li > a"
  end

  test "workshop titles" do
    get "/personal_website/"

    assert_select "title", "Personal Website | Hack Club Workshops"
  end

<<<<<<< 5fff1bfce34889cecccf7ddb64f26a6c98f922a6
  test 'passes correct page tracking metadata' do
    # view the workshop without signing in
    get '/personal_website/'
=======
  test "passes metadata to analytics on workshop view" do
    get "/personal_website/"
>>>>>>> Format tests to comply with houndci

    expected = nil
    actual = @controller.instance_variable_get(:@metadata_should_not_track_page)

<<<<<<< 5fff1bfce34889cecccf7ddb64f26a6c98f922a6
    assert_equal expected, actual

    # sign in and view the workshop
    get '/auth/github/callback'
    get '/personal_website/'

    expected = true
    actual = @controller.instance_variable_get(:@metadata_should_not_track_page)

    assert_equal expected, actual
=======
    assert_equal "Personal Website", page_name
    assert_equal "Workshop", page_category
>>>>>>> Format tests to comply with houndci
  end

  test "redirects workshops when no trailing slash" do
    get "/personal_website"

    assert_redirected_to "/personal_website/"
  end

  test "returns 404 when workshop doesn't exist" do
    assert_raises ActionController::RoutingError do
      get "/invalid_workshop/"
    end
  end

  test "retrieves regular file from workshop" do
    get "/personal_website/img/final_screenshot.png"

    assert_equal "image/png", response.content_type
  end

  test "renders markdown files from workshops" do
    get "/personal_website/README.md"

    assert_select ".workshop-contents > h1", "Personal Website"
  end

  test "title with markdown files in workshops" do
    get "/personal_website/README.md"

    assert_select "title", "README.md | Hack Club Workshops"
  end

  test "returns 404 when regular file doesn't exist" do
    assert_raises ActionController::RoutingError do
      get "/personal_website/fake_file.png"
    end

    assert_raises ActionController::RoutingError do
      get "/fake.txt"
    end
  end

  test "returns 404 when markdown file doesn't exist" do
    assert_raises ActionController::RoutingError do
      get "/personal_website/FAKE.md"
    end

    assert_raises ActionController::RoutingError do
      get "/fake.md"
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
