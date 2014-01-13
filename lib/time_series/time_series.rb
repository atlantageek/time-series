class TimeSeries
  def initialize
    @data_points = {}
  end

  def <<(data_point)
    @data_points[data_point.timestamp] = data_point.data
  end

  def at(timestamp)
    @data_points[timestamp]
  end

  def length
    @data_points.length
  end
end
