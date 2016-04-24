class Connection
  attr_accessor :manager, :error, :index, :uid, :name, :first_name, :last_name, :url, :location

  def create_from_index! index, user
    @manager = ConnectionManager.new user
    @index = index.to_i
    @manager.retrieve_connection(self)
    create_user_from_self unless self.error
    self
  end

  def create_from_user! user
    @uid = user.uid
    @name = "#{user.first_name} #{user.last_name}"
    @url = user.image
    @location = user.location
    self
  end

  private

  def create_user_from_self
    user = User.find_or_initialize_by(uid: uid)
    user.update_attributes({
      image: url,
      first_name: first_name,
      last_name: last_name,
      location: location,
    }) if user.new_record?
  end
end
