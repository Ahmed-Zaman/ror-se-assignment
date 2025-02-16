module SortableHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    css_class = column == params[:sort] ? "current #{params[:direction]}" : nil
    
    content_tag(:div, class: 'd-flex align-items-center') do
      link_to({ sort: column, direction: direction }, class: "text-decoration-none text-dark #{css_class}") do
        safe_join([
          title,
          content_tag(:i, '', class: sort_icon_class(column))
        ])
      end
    end
  end

  private

  def sort_icon_class(column)
    return "bi bi-arrow-down-up text-muted ms-1" unless column == params[:sort]
    
    if params[:direction] == 'asc'
      "bi bi-arrow-up text-primary ms-1"
    else
      "bi bi-arrow-down text-primary ms-1"
    end
  end
end 