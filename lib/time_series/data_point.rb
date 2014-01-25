class DataPoint
  include Comparable

  attr_reader :timestamp, :data

  def initialize(timestamp, data)
    timestamp = timestamp.to_time unless timestamp.kind_of? Time
    @timestamp, @data = timestamp, data
  end

  def <=>(another)
    result = @timestamp <=> another.timestamp
  end

  def ==(another)
    @timestamp == another.timestamp and @data == another.data
  end
end
