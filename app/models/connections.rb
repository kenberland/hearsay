class Connections
  attr_accessor :connections

  def initialize args
    @connections = Array.new
    args.each do |c|
      @connections.push Connection.new c
    end
  end

  def count
    connections.size
  end

  def [](y)
    connections[y % count]
  end

end

class Connection
  attr_accessor :uid, :name, :url

  def initialize connection
    @uid = connection['id']
    @name = connection['name']
    @url = connection['picture']['data']['url']
    create_user_from_connection(connection)
  end

  def create_user_from_connection(connection_data)
    user = User.find_or_create_by(uid: @uid)
    user.update_attributes({
      image: @url,
      first_name: connection_data['first_name'],
      last_name: connection_data['last_name'],
    })
  end
end

