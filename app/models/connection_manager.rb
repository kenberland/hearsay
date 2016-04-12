EXPIRY_TIME = 10.minutes
SEGMENT_SIZE = 5

class ConnectionManager
  attr_accessor :api, :user, :segment, :index

  def initialize user
    @user = user
    @api = Koala::Facebook::API.new user.token
  end

  def retrieve_connection connection
    @index = connection.index
    @segment = get_segment(connection.index/SEGMENT_SIZE)
    cache_connections_in_segment(segment)
    if segment_connection = segment[connection.index % SEGMENT_SIZE]
      populate_connection(connection, Hashie::Mash.new(segment_connection))
    else
      connection.error = :out_of_range
    end
  end

  def get_segment s
    key = "connection_map/#{user.uid}/#{s}"
    Rails.cache.fetch(key, expires_in: EXPIRY_TIME) do
      api.get_connections('me', 'friends?fields=id,name,picture.type(large),first_name,last_name,location', { :offset => s * SEGMENT_SIZE, :limit => 5 })
    end
  end

  def cache_connections_in_segment segment
    segment.each do |connection|
      cache_connection(Hashie::Mash.new connection)
    end
  end

  def cache_connection connection
    key = "connection/#{connection.id}"
    Rails.cache.fetch(key, expires_in: EXPIRY_TIME) do
      connection
    end
  end

  def populate_connection connection, segment_connection
    connection.uid = segment_connection.id
    connection.name = segment_connection.name
    connection.first_name = segment_connection.first_name
    connection.last_name = segment_connection.last_name
    connection.url = segment_connection.picture.data.url
    connection.location = segment_connection.location.name rescue nil
  end
end
