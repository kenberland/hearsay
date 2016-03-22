module ApplicationHelper
  def current_user
    self.controller.current_user
  end

  def font_awesomeify(category)
    case category
    when 'finance'
      'fa-money'
    when 'work'
      'fa-briefcase'
    when 'relationships'
      'fa-heart'
    when 'school'
      'fa-book'
    when 'sports'
      'fa-futbol-o'
    when 'roommates'
      'fa-users'
    else
      'fa-question-circle'
    end
  end

  def tag_category(all_tag_categories, tag)
    all_tag_categories[tag.tag_category_id]
  end

  def current_tag(user_tags, current_tag_info)
    user_tags.select{|tag| tag.id == current_tag_info.last}.first
  end
end
