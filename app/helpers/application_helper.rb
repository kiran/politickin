module ApplicationHelper

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end


  def sortable(column, title = nil)
    title ||= column.titleize
    current = (column == sort_column)
    css_class = current ? "current #{sort_direction}" : nil
    direction = (current && sort_direction == "asc") ? "desc" : "asc"
    if current
      arrow = sort_direction=='asc' ? '-up' : '-down'
    else
      arrow = nil
    end
    link_to congressmen_path(:sort => column, :direction => direction), {:class => css_class} do
      yield( arrow )
    end
  end
end
