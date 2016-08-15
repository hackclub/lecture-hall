require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:basic)
    super
  end
  test 'successfully creates with omniauth' do
    auth = @mock_auth
    orig_count = User.count

    user = User.create_with_omniauth(auth)

    assert_equal(orig_count+1, User.count)

    assert_equal(auth[:provider], user.provider)
    assert_equal(auth[:uid], user.uid)
    assert_equal(auth[:info][:name], user.name)
  end

  test 'has many projects' do
    assert_difference '@user.projects.count' do
      @user.projects.create(name: 'Test')
    end
  end
end
