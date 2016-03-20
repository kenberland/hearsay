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
end
