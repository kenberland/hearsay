EXPIRY_TIME = 10.minutes

class Connections
  attr_accessor :connections, :map, :api

  def initialize user
    @connections = Array.new
    @map = Hash.new
    @api = Koala::Facebook::API.new user.token
    load_connections user.uid
  end

  def find_by_uid uid
    connections[map[uid]]
  end

  def count
    connections.size
  end

  def [](y)
    connections[y % count]
  end

  private

  def load_connections uid
    get_connections(uid).each_with_index do |connection, index|
      @connections.push(Connection.new(cache_connection(connection)))
      @map[@connections.last.uid] = index
    end
  end

  def cache_connection connection
    Rails.cache.fetch("connection/#{connection['id']}", expires_in: EXPIRY_TIME) do
      connection
    end
  end

  def get_connections uid
    key = "#{uid}/connections"
    load_more_connections if Rails.cache.exist?(key)
    Rails.cache.fetch(key, expires_in: EXPIRY_TIME) do
      fetch_connections
    end
  end

  def fetch_connections
    api.get_connections('me', 'friends?fields=id,name,picture.type(large),first_name,last_name', { :limit => 25 })
  end

  def load_more_connections
    Rails.logger.error 'X' * 100
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
