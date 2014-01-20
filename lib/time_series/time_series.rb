class TimeSeries
  include Enumerable

  attr_reader :data_points

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

  def at(*timestamps)
    results = @data_points.values_at(*timestamps)
    results = results[0] if results.length == 1

    return results
  end

  def slice(timeframe)
    from, to = timeframe[:from], timeframe[:to]

    data_points = @data_points.select do |t, data|
      case [!from.nil?, !to.nil?]
      when [true, true] then t >= from and t <= to
      when [true, false] then t >= from
      when [false, true] then t <= to
      end
    end

    return TimeSeries.new data_points
  end

  def each(&block)
    Hash[@data_points.sort].values.each(&block)
  end

  def last(n = 1)
    Hash[@data_points.sort.last(n)].values
  end

  def length
    @data_points.length
  end
end
