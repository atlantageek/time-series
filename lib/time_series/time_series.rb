class TimeSeries < Hash
  def <<(data_point)
    self[data_point.timestamp] = data_point.data
  end

  def at(timestamp)
    self[timestamp]
  end
end
