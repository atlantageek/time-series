require 'spec_helper'

describe TimeSeries do
  let(:data_points) do
    data_points = {
      Time.at(2000000000) => "The second Unix billennium",
      Time.at(1234567890) => "Let's go party",
      Time.at(1000000000) => "The first Unix billennium",
      Time.at(2147485547) => "Year 2038 problem"
    }
    data_points.keys.zip(data_points.values).collect { |dp| DataPoint.new(dp[0], dp[1]) }
  end
  let(:time_series) { TimeSeries.new(data_points) }

  describe "#new" do
    it "takes a array of DataPoints" do
      expect(time_series.length).to eql 4
    end

    it "takes a array of timestamps and a array of data" do
      data_points = time_series.data_points
      time_series = TimeSeries.new(data_points.keys, data_points.values)
      expect(time_series.length).to eql 4
    end
  end

  describe "#<<" do
    it "adds a new data point" do
      time_series << DataPoint.new(Time.now, "Knock knock")
      expect(time_series.length).to eql 5
    end

    it "update the existing data point" do
      time_series << DataPoint.new(Time.at(1234567890), 'PARTY TIME!')
      expect(time_series.length).to eql 4
      expect(time_series.at(Time.at(1234567890)).data).to eql 'PARTY TIME!'
    end
  end

  describe "#at" do
    it "returns data associated with the given timestamp" do
      expect(time_series.at(Time.at(1000000000)).data).to eq "The first Unix billennium"
    end

    it "returns data in array if two or more timestamps are given" do
      expect(time_series.at(Time.at(1000000000), Time.at(2000000000))
        .collect { |data_point| data_point.data }).to eql(["The first Unix billennium", "The second Unix billennium"])
    end
  end

  describe "#slice" do
    it "returns all data points in the given timeframe" do
      ts = time_series.slice from: Time.at(1000000000), to: Time.at(2000000000)
      expect(ts.length).to eq 3
      expect(ts.at(Time.at 2147485547)).to be nil
    end

    it "returns all data points after the from time" do
      ts = time_series.slice from: Time.at(2000000000)
      expect(ts.length).to eq 2
      expect(ts.at(Time.at(1000000000), Time.at(1234567890))).to eq [nil, nil]
    end

    it "returns all data points before the to time" do
      ts = time_series.slice to: Time.at(1234567890)
      expect(ts.length).to eq 2
      expect(ts.at(Time.at(2000000000), Time.at(2147485547))).to eq [nil, nil]
    end
  end

  describe "is enumerable" do
    it "returns the first data point(s) according to its timestamp" do
      expect(time_series.first.data).to eq "The first Unix billennium"
      expect(time_series.first(2).collect { |data_point| data_point.data }).to eql ["The first Unix billennium", "Let's go party"]
    end

    it "returns the last data point(s) according to its timestamp" do
      expect(time_series.last.data).to eq "Year 2038 problem"
      expect(time_series.last(2).collect { |data_point| data_point.data }).to eq ["The second Unix billennium", "Year 2038 problem"]
    end
  end

  describe "#to_a" do
    it "returns a array of sorted DataPoints" do
      expect(time_series.to_a).to be_a_kind_of Array
      expect(time_series.to_a).to eq data_points.sort
    end
  end

  let(:second_data_points) do
    data_points = {
      Time.at(1457676710) => 1, #at 2016/3/11 06:11:50
      Time.at(1457676700) => 27, #at 2016/3/11/06:11:40
      Time.at(1457676670) => 44, #at 2016/3/11/06:11:10
      Time.at(1457676490) => 44, #at 2016/3/11/06:08:10
      Time.at(1457676485) => 22, #at 2016/3/11/06:08:05
    }
    data_points.keys.zip(data_points.values).collect { |dp| DataPoint.new(dp[0], dp[1]) }
  end

  let(:second_time_series) { TimeSeries.new(second_data_points) }
  describe "resample seconds to minutes" do
    it "takes a timeseries and resamples it up to the minute time range length should equal 2" do
        minute_time_series = second_time_series.resample(:minute, :avg)
        expect(minute_time_series.length).to eql 2
        timestamps = Hash[minute_time_series.data_points.sort].keys
        values = Hash[minute_time_series.data_points.sort].values
	expect(timestamps[0].to_i).to eql 1457676480
	expect(timestamps[1].to_i).to eql 1457676660

	expect(values[0].data.to_i).to eql 33
	expect(values[1].data.to_i).to eql 24
    end
  end

  let(:third_data_points) do
    data_points = {
      Time.at(1457676710) => 1, #at 2016/3/11 06:11:50
      Time.at(1455323294) => 27, #at 2016/2/13/00:28:14
      Time.at(1455668894) => 44, #at 2016/2/17/00:28:14
      Time.at(1452990494) => 44, #at 2016/1/17/00:28:14
      Time.at(1452904094) => 22, #at 2016/1/15/06:08:05
    }
    data_points.keys.zip(data_points.values).collect { |dp| DataPoint.new(dp[0], dp[1]) }
  end
  let(:third_time_series) { TimeSeries.new(third_data_points) }
  describe "resample seconds to months" do
    it "takes a timeseries and resamples it up to the month time range length should equal 3" do
        month_time_series = third_time_series.resample(:month, :avg)
        expect(month_time_series.length).to eql 3
        timestamps = Hash[month_time_series.data_points.sort].keys
        values = Hash[month_time_series.data_points.sort].values
	expect(timestamps[0].to_i).to eql 1451624400
	expect(timestamps[1].to_i).to eql 1454302800
	expect(timestamps[2].to_i).to eql 1456808400

	expect(values[0].data.to_i).to eql 33
	expect(values[1].data.to_i).to eql 35
	expect(values[2].data.to_i).to eql 1
    end
  end
end
