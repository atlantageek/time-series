class DataPoint
  attr_reader :timestamp, :data

  def initialize(timestamp, data)
    @timestamp, @data = timestamp, data
  end
end
