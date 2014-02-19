class TimeSeries
  include Enumerable

  attr_reader :data_points

  def initialize(*args)
    case args.length
    when 1 then data_points = args[0]
    when 2 then data_points = args[0].zip(args[1]).collect { |dp| DataPoint.new(dp[0], dp[1]) }
    else data_points = []
    end

    @data_points = {}
    self << data_points
  end

  def <<(*data_points)
    data_points.flatten.each do |data_point|
      @data_points[data_point.timestamp] = data_point
    end
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

    return self.class.new data_points.keys, data_points.values
  end

  def each(&block)
    Hash[@data_points.sort].values.each(&block)
  end

  def last(n = 1)
    results = Hash[@data_points.sort.last(n)].values
    results = results[0] if results.length == 1

    return results
  end

  def length
    @data_points.length
  end

  def to_a
    Hash[@data_points.sort].values
  end
end
