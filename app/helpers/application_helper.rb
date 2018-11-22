module ApplicationHelper

  def format_list_name(name)
    name.gsub('_', ' ')
  end
end
