module ApplicationHelper
  def full_title(page_title=nil)
    base_title = 'Hack Club Workshops'

    unless page_title
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
