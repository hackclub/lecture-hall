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

  test 'passes metadata to analytics on workshop view' do
    get '/personal_website/'

    page_name = @controller.instance_variable_get(:@metadata_page_name)
    page_category = @controller.instance_variable_get(:@metadata_page_category)

    assert_equal 'Personal Website', page_name
    assert_equal 'Workshop', page_category
  end

  test 'redirects workshops when no trailing slash' do
    get '/personal_website'

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
    get '/personal_website/README.md'

    assert_select '.workshop-contents > h1', 'Personal Website'
  end

  test 'title with markdown files in workshops' do
    get '/personal_website/README.md'

    assert_select 'title', 'README.md | Hack Club Workshops'
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
end
