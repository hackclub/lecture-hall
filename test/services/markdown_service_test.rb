require 'test_helper'

class MarkdownServiceTest < ActiveSupport::TestCase
  test 'it renders markdown' do
    input = '_test_'
    expected = "<p><em>test</em></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'it automatically creates links' do
    input = 'https://example.com'
    expected = "<p><a href=\"https://example.com\">https://example.com</a></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'it supports tables' do
    input = %q(
| Test | Test |
| ---- | ---- |
| Val  | Val  |
)
    output = MarkdownService.new.render(input)

    assert(output.include? '<table>')
  end

  test 'it supports strikethrough' do
    input = '~~test~~'
    expected = "<p><del>test</del></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'it supports fenced code blocks' do
    input = %q(
```js
console.log('test');
```
)
    output = MarkdownService.new.render(input)

    assert(output.include? 'pre')
  end

  test 'it makes headers linkable' do
    input = '# test'
    expected = "<h1 id=\"test\">test</h1>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end
end
