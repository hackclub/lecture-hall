class ApplicationHelperTest < ActionView::TestCase
  include SessionsHelper

  test 'full_title formatting when given input' do
    input = 'Test'
    expected = 'Test | Hack Club Workshops'
    actual = full_title(input)

    assert_equal expected, actual
  end

  test 'full_title formatting with no input' do
    expected = 'Hack Club Workshops'
    actual = full_title

    assert_equal expected, actual
  end

  test 'json_metadata when not logged in' do
    expected = {}
    actual = metadata

    assert_equal expected, actual
  end

  test 'json_metadata when logged in' do
    sign_in users(:basic)

    expected = { current_user: { id: current_user.id} }
    actual = metadata

    assert_equal expected, actual
  end

  test 'json_metadata with page category' do
    @metadata_page_category = 'Test'

    expected = { analytics: { page_category: 'Test' } }
    actual = metadata

    assert_equal expected, actual
  end

  test 'json_metadata with page name' do
    @metadata_page_name = 'Test'

    expected = { analytics: { page_name: 'Test' } }
    actual = metadata

    assert_equal expected, actual
  end
end
