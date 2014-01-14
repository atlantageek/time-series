class TimeSeries
  def initialize(*args)
    case args.length
    when 1 then data_points = args[0]
    when 2 then data_points = Hash[args[0].zip(args[1])]
    else data_points = {}
    end

    @data_points = data_points
  end

  def <<(data_point)
    @data_points[data_point.timestamp] = data_point.data
  end

  def at(*timestamp)
    results = @data_points.values_at(*timestamp)
    results = results[0] if results.length == 1

    return results
  end

  def length
    @data_points.length
  end
end
