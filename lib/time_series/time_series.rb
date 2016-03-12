class Time
  # Time#round already exists with different meaning in Ruby 1.9
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
end

require 'pry'

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

    return self.class.new(data_points.keys, data_points.values)
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

  def period_lookup(time_period)
    case time_period
    when :second
        return 1
    when :minute
        return 60
    when :hour
        return 3600
    when :day
        return 86400
    when :week
        return 604800
    else
        return -1
    end
  end

  def max(keys, hsh)
    hsh[keys.max {|a,b| hsh[a].data <=> hsh[b].data}]
  end

  def min(keys, hsh)
    hsh[keys.min {|a,b| hsh[a].data <=> hsh[b].data}]
  end

  def avg(keys, hsh)
    sum = keys.inject(0){ |a,b| a+hsh[b].data}
    sum/keys.length
  end

  def round_to_month(secs)
    t1 = Time.at secs
    t2 = (t1.to_datetime >> 1).to_time
    s1 = Time.new(t1.year, month=t1.month)
    s2 = Time.new(t2.year, month=t2.month)
    (t1-s1) < (s2-t1) ? s1 : s2
  end

  def round_to_nearest(tm, time_period)
    #grouping
    multiplier = period_lookup(time_period)
    result = 0
    if (multiplier > 0)
      result = Time.at((tm.to_i / multiplier).floor * multiplier)
    end
    result
  end

  def resample(time_period, fnc_id)
    hsh = Hash[@data_points.sort]
    seconds = period_lookup(time_period)
    #Hash[@data_points.sort].values.each(&block)
    groups = hsh.keys.group_by{|tm| 
      round_to_nearest(tm, time_period)
    }

    result={}
    case fnc_id
    when :max
       fn = lambda{|data| max(data, hsh)}
    when :min
       fn = lambda{|data| min(data, hsh)}
    when :avg
       fn = lambda{|data| avg(data,hsh)}
    end
    groups.each_pair {|key,value|
      result[key] = fn.call(groups[key])
    }
    return self.class.new(result.keys, result.values)
  end
end
