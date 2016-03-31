class Connection
  attr_accessor :manager, :error, :index, :uid, :name, :first_name, :last_name, :url

  def initialize index, user
    @manager = ConnectionManager.new user
    @index = index.to_i
    @manager.retrieve_connection(self)
    create_user_from_self unless self.error
  end

  def create_user_from_self
    user = User.find_or_initialize_by(uid: uid)
    user.update_attributes({
      image: url,
      first_name: first_name,
      last_name: last_name,
    }) if user.new_record?
  end
end
