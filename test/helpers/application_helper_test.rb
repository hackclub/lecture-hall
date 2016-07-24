class ApplicationHelperTest < ActionView::TestCase
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
end
