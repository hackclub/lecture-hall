module ApplicationHelper
  def full_title(page_title='')
    base_title = 'Hack Club Workshops'

    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # Metadata constructs a hash of metadata to be used by JavaScript.
  #
  # The current user's ID is automatically included in the metadata if the user
  # is logged in.
  #
  # The following variables can be set in controllers to further customize the
  # metadata:
  #
  # Analytics:
  #
  #   # Category of page to give to analytics
  #   - @metadata_page_category
  #   # Name of page to pass to analytics
  #   - @metadata_page_name
  def metadata
    metadata = {}

    page_category = @metadata_page_category
    page_name = @metadata_page_name

    if page_category || page_name
      metadata[:analytics] ||= {}

      metadata[:analytics][:page_category] = page_category if page_category
      metadata[:analytics][:page_name] = page_name if page_name
    end

    if current_user
      metadata[:current_user] = {
        id: current_user.id
      }
    end

    metadata
  end
end
