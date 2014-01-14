require 'spec_helper'

describe TimeSeries do
  let(:time_series) { TimeSeries.new }
  let(:timestamp)   { Time.now }
  let(:data)        { { a: 1, b:2, c:3 } }

  before { time_series << DataPoint.new(timestamp, data) }

  describe "#new" do
    let(:data_points) do
      {
        Time.at(1000000000) => "The first Unix billennium",
        Time.at(1234567890) => "Let's go party",
        Time.at(2000000000) => "The second Unix billennium", 
        Time.at(2147485547) => "Year 2038 problem"
      }
    end

    it "takes a Hash" do
      time_series = TimeSeries.new(data_points)
      time_series.length.should eql 4
    end

    it "takes a array of timestamps and a array of data" do
      time_series = TimeSeries.new(data_points.keys, data_points.values)
      time_series.length.should eql 4
    end
  end

  describe "#<<" do
    it "adds a new data point" do
      time_series.length.should eql 1
    end

    it "update the existing data point" do
      time_series << DataPoint.new(timestamp, 'some new data')
      time_series.length.should eql 1
      time_series.at(timestamp).should eql 'some new data'
    end
  end

  describe "#at" do
    it "returns data associated with the given timestamp" do
      time_series.at(timestamp).should eql data
    end

    it "returns data in array if two or more timestamps are given" do
      timestamp_2 = Time.now
      data_2 = 'some new data'
      time_series << DataPoint.new(timestamp_2, data_2)
      time_series.at(timestamp, timestamp_2).should eql [data, data_2]
    end
  end
end
