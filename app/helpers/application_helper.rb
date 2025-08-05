module ApplicationHelper
  def item_status(item, current_user)
    match = item.matches.find do |m|
      m.lost_item.user_id == current_user.id || m.found_item.user_id == current_user.id
    end

    if match
      if match.confirmed?
        content_tag(:span, "Match confirmed", class: "status-confirmed")
      else
        content_tag(:span, "Possible match found", class: "status-possible")
      end
    else
      content_tag(:span, "Pending match", class: "status-pending")
    end
  end
end
