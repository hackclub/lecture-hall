class FakeAnalyticsRuby
  def initialize
    @identified_users = []
    @tracked_events = EventsList.new([])
    @tracked_page_views = PageViewsList.new([])
  end

  def identify(user)
    @identified_users << user
  end

  def track(options)
    @tracked_events << options
  end

  def page(options)
    @tracked_page_views << options
  end

  delegate :tracked_events_for, to: :tracked_events
  delegate :tracked_page_views_for, to: :tracked_page_views

  def has_identified?(user, traits = {})
    @identified_users.any? do |user_hash|
      user_hash[:user_id] == user.id &&
        traits.all? do |key, value|
          user_hash[:traits][key] == value
        end
    end
  end

  private

  attr_reader :tracked_events
  attr_reader :tracked_page_views

  class TrackedList
    def initialize(tracked)
      @tracked = tracked
    end

    def <<(to_track)
      @tracked << to_track
    end

    def tracked_for(user)
      select_for_match(:user_id, user.id)
    end

    def has_properties?(options)
      tracked.any? do |event|
        (options.to_a - event[:properties].to_a).empty?
      end
    end

    protected

    attr_reader :tracked

    def select_for_match(key, value)
      self.class.new(
        tracked.select do |action|
          action[key] == value
        end
      )
    end
  end

  class EventsList < TrackedList
    alias_method :tracked_events_for, :tracked_for

    def named(event_name)
      select_for_match(:event, event_name)
    end
  end

  class PageViewsList < TrackedList
    alias_method :tracked_page_views_for, :tracked_for

    def named(page_name)
      select_for_match(:name, page_name)
    end

    def with_category(category)
      select_for_match(:category, category)
    end
  end
end
