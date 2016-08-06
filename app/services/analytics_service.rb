class AnalyticsService
  class_attribute :backend
  self.backend = Segment::Analytics.new(
    {
      write_key: Rails.application.secrets.segment_write_key
    }
  )

  # Events
  USER_SIGN_IN = 'Sign In User'
  USER_SIGN_OUT = 'Sign Out User'

  WORKSHOP_VIEW = 'View Workshop'

  def initialize(user)
    @user = user
  end

  def track_user_sign_in
    identify
    track(
      {
        user_id: user.id,
        event: USER_SIGN_IN
      }
    )
  end

  def track_user_sign_out
    identify
    track(
      {
        user_id: user.id,
        event: USER_SIGN_OUT
      }
    )
  end

  def track_view_workshop(workshop_name)
    identify
    track(
      {
        user_id: user.id,
        event: WORKSHOP_VIEW,
        properties: {
          workshop: workshop_name
        }
      }
    )
  end

  private

  def identify
    backend.identify(identify_params)
  end

  attr_reader :user

  def identify_params
    {
      user_id: user.id,
      traits: user_traits
    }
  end

  def user_traits
    {
      name: user.name
    }.reject { |key, value| value.blank? }

  end

  def track(options)
    backend.track(options)
  end
end
