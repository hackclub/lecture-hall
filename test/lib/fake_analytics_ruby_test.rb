class FakeAnalyticsRubyTest < ActiveSupport::TestCase
  def setup
    @user = users(:basic)
    @analytics = FakeAnalyticsRuby.new
  end

  test 'it properly records and looks up user identification' do
    def expect(expected, user, traits=nil)
      actual = @analytics.has_identified? user, traits
      assert_equal(expected, actual)
    end

    def identify_params(user, traits)
      { user_id: user.id, traits: traits }
    end

    traits = { foo: :bar }

    expect(false, @user, traits)
    @analytics.identify(identify_params(@user, traits))
    expect(true, @user, traits)
  end

  test 'it properly records and looks up tracked events' do
    def expect(expected, user, name, properties=nil)
      actual = @analytics.tracked_events_for(user)
               .named(name)
               .has_properties? properties
      assert_equal(expected, actual)
    end

    # No properties
    expect(false, @user, 'Test')
    @analytics.track(
      user_id: @user.id,
      event: 'Test'
    )
    expect(true, @user, 'Test')

    # With properties
    props = { location: 'Planet Earth' }

    expect(false, @user, 'Properties test', props)
    @analytics.track(
      user_id: @user.id,
      event: 'Properties test',
      properties: props
    )
    expect(true, @user, 'Properties test', props)
  end

  test 'it properly records and looks up tracked page views' do
    def expect(expected, user, name, category, properties=nil)
      actual = @analytics.tracked_page_views_for(user)
               .named(name)
               .with_category(category)
               .has_properties? properties
      assert_equal(expected, actual)
    end

    # No properties
    expect(false, @user, 'Testy McTestface', 'Aquatic Vehicles')
    @analytics.page(
      user_id: @user.id,
      category: 'Aquatic Vehicles',
      name: 'Testy McTestface'
    )
    expect(true, @user, 'Testy McTestface', 'Aquatic Vehicles')

    # With properties
    props = { url: 'https://testymctestface.com' }

    expect(false, @user, 'Testy McTestface', 'Aquatic Vehicles', props)
    @analytics.page(
      user_id: @user.id,
      category: 'Aquatic Vehicles',
      name: 'Testy McTestface',
      properties: props
    )
    expect(true, @user, 'Testy McTestface', 'Aquatic Vehicles', props)
  end
end
