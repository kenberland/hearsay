module ApplicationHelper
  def current_user
    self.controller.current_user
  end
end
