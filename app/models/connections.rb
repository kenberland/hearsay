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
   connections[y % connections.size]
 end

end

class Connection
  attr_accessor :uid, :name, :url

  def initialize connection
    @uid = connection['id']
    @name = connection['name']
    @url = connection['picture']['data']['url']
  end
end
