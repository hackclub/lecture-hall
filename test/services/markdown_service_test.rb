require 'test_helper'

class MarkdownServiceTest < ActiveSupport::TestCase
  test 'it renders markdown' do
    input = '_test_'
    expected = "<p><em>test</em></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'it parses emoji' do
    input = 'Test :see_no_evil: :speak_no_evil: :hear_no_evil'
    expected = '<p>Test 🙈 🙊 🙉</p>'
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'it automatically creates links' do
    input = 'https://example.com'
    expected = "<p><a href=\"https://example.com\" target=\"_blank\" rel=\"noreferrer\">https://example.com</a></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'links to relative pages' do
    input = '[Content](../page.md "Title")'
    expected = "<p><a href=\"../page.md\" title=\"Title\">Content</a></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(output, expected)
  end

  test 'links to other pages in new tabs' do
    input = '[Content](https://example.com "Title")'
    expected = "<p><a href=\"https://example.com\" title=\"Title\" target=\"_blank\" rel=\"noreferrer\">Content</a></p>\n"
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

  test 'it renders sidebars' do
    # Complete example where the last header has children
    input1 = %Q(
# Lorem Ipsum

## Dolor Sit Amet

### Consectetur Adipiscing Elit

### Morbi Eu Congue

## Praesent In Eros

## Etiam Metus Augue

### Commodo Urna
).strip
    expected1 = %Q(
<nav class="workshop-sidebar hidden-print hidden-xs hidden-sm affix">
  <ul id="sidebar" class="nav nav-stacked fixed">
    <li>
      <a href="#dolor-sit-amet">Dolor Sit Amet</a>
      <ul class="nav nav-stacked">
        <li><a href="#consectetur-adipiscing-elit">Consectetur Adipiscing Elit</a></li>
        <li><a href="#morbi-eu-congue">Morbi Eu Congue</a></li>
      </ul>
    </li>
    <li>
      <a href="#praesent-in-eros">Praesent In Eros</a>
    </li>
    <li>
      <a href="#etiam-metus-augue">Etiam Metus Augue</a>
      <ul class="nav nav-stacked">
        <li><a href="#commodo-urna">Commodo Urna</a></li>
      </ul>
    </li>
  </ul>
</nav>
).strip

    # Short test where the last header has no children
    input2 = %Q(
## Dolor Sit Amet

### Consectetur Adipiscing Elit

## Etiam Metus Augue
).strip
    expected2 = %Q(
<nav class="workshop-sidebar hidden-print hidden-xs hidden-sm affix">
  <ul id="sidebar" class="nav nav-stacked fixed">
    <li>
      <a href="#dolor-sit-amet">Dolor Sit Amet</a>
      <ul class="nav nav-stacked">
        <li><a href="#consectetur-adipiscing-elit">Consectetur Adipiscing Elit</a></li>
      </ul>
    </li>
    <li>
      <a href="#etiam-metus-augue">Etiam Metus Augue</a>
    </li>
  </ul>
</nav>
).strip

    output1 = MarkdownService.new.render_sidebar(input1)
    output2 = MarkdownService.new.render_sidebar(input2)

    assert_equal(expected1, output1)
    assert_equal(expected2, output2)
  end
end
