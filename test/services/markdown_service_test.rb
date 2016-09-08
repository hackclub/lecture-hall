# coding: utf-8
require 'test_helper'

class MarkdownServiceTest < ActiveSupport::TestCase
  test 'it renders markdown' do
    input = '_test_'
    expected = "<p><em>test</em></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
  end

  test 'it parses emoji' do
    input = 'Test :see_no_evil:'
    expected = %Q(<p>Test <img src="/images/emoji/unicode/1f648.png" alt=":see_no_evil:" class="emoji"></p>\n)
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
  end

  test 'it automatically creates links' do
    input = 'https://example.com'
    expected = "<p><a href=\"https://example.com\" target=\"_blank\" rel=\"noreferrer\">https://example.com</a></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
  end

  test 'links to relative pages' do
    input = '[Content](../page.md "Title")'
    expected = "<p><a href=\"../page.md\" title=\"Title\">Content</a></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
  end

  test 'links to other pages in new tabs' do
    input = '[Content](https://example.com "Title")'
    expected = "<p><a href=\"https://example.com\" title=\"Title\" target=\"_blank\" rel=\"noreferrer\">Content</a></p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
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

    assert_equal(expected, output)
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

    assert_equal(expected, output)
  end

  test "it converts -- to an endash" do
    input = "wow -- this is crazy!"
    expected = "<p>wow &ndash; this is crazy!</p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
  end

  test "it converts --- to an emdash" do
    input = "some random --- text"
    expected = "<p>some random &mdash; text</p>\n"
    output = MarkdownService.new.render(input)

    assert_equal(expected, output)
  end

  # rubocop:disable Metrics/LineLength, Style/StringLiterals
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
      <a href="#dolor-sit-amet"><p>Dolor Sit Amet</p></a>
      <ul class="nav nav-stacked">
        <li><a href="#consectetur-adipiscing-elit"><p>Consectetur Adipiscing Elit</p></a></li>
        <li><a href="#morbi-eu-congue"><p>Morbi Eu Congue</p></a></li>
      </ul>
    </li>
    <li>
      <a href="#praesent-in-eros"><p>Praesent In Eros</p></a>
    </li>
    <li>
      <a href="#etiam-metus-augue"><p>Etiam Metus Augue</p></a>
      <ul class="nav nav-stacked">
        <li><a href="#commodo-urna"><p>Commodo Urna</p></a></li>
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
      <a href="#dolor-sit-amet"><p>Dolor Sit Amet</p></a>
      <ul class="nav nav-stacked">
        <li><a href="#consectetur-adipiscing-elit"><p>Consectetur Adipiscing Elit</p></a></li>
      </ul>
    </li>
    <li>
      <a href="#etiam-metus-augue"><p>Etiam Metus Augue</p></a>
    </li>
  </ul>
</nav>
).strip

    output1 = MarkdownService.new.render_sidebar(input1)
    output2 = MarkdownService.new.render_sidebar(input2)

    assert_equal(expected1, output1)
    assert_equal(expected2, output2)
  end

  test "it renders Markdown in sidebar links" do
    input = %(
## `<marquee>` Cringe 101 is leaking

### `<b>` Please make it stop
).strip

    expected = %(
<nav class="workshop-sidebar hidden-print hidden-xs hidden-sm affix">
  <ul id="sidebar" class="nav nav-stacked fixed">
    <li>
      <a href="#marquee-cringe-101-is-leaking"><p><code>&lt;marquee&gt;</code> Cringe 101 is leaking</p></a>
      <ul class="nav nav-stacked">
        <li><a href="#b-please-make-it-stop"><p><code>&lt;b&gt;</code> Please make it stop</p></a></li>
      </ul>
    </li>
  </ul>
</nav>
).strip

    actual = MarkdownService.new.render_sidebar(input)
    assert_equal(expected, actual)
  end
  # rubocop:enable Metrics/LineLength, Style/StringLiterals

  test "sidebars convert -- to an endash" do
    input = "## foo -- bar"
    sidebar = MarkdownService.new.render_sidebar(input)

    assert sidebar.include? "&ndash;"
  end

  test "sidebars convert --- to an emdash" do
    input = "## foo --- bar"
    sidebar = MarkdownService.new.render_sidebar(input)

    assert sidebar.include? "&mdash;"
  end
end
