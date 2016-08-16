require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def setup
    @project = projects(:personal_website)
    super
  end

  test "expected attributes are available" do
    expected_attributes = [
      :user,
      :name,
      :live_url
    ]

    expected_attributes.each do |a|
      assert @project.respond_to?(a), "Expected project to respond to #{a}"
    end
  end

  test "expected attributes are required" do
    required_attributes = [
      :user,
      :name
    ]

    required_attributes.each do |a|
      original_value = @project.public_send(a)
      @project.public_send("#{a}=", nil)

      assert_not(
        @project.valid?,
        "Expected project to be invalid when #{a} isn't set"
      )

      @project.public_send("#{a}=", original_value)
    end
  end

  test "live_url must be a valid url" do
    @project.live_url = "this is not a url"
    assert_not @project.valid?

    @project.live_url = "https://example.com"
    assert @project.valid?
  end

  test "live_url must be able to be nil" do
    @project.live_url = nil
    assert @project.valid?
  end
end
