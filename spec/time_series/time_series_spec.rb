require 'spec_helper'

describe TimeSeries do
  let(:data_points) do
    {
      Time.at(2000000000) => "The second Unix billennium",
      Time.at(1234567890) => "Let's go party",
      Time.at(1000000000) => "The first Unix billennium",
      Time.at(2147485547) => "Year 2038 problem"
    }
  end
  let(:time_series) { TimeSeries.new(data_points) }

  describe "#new" do
    it "takes a Hash" do
      time_series.length.should eql 4
    end

    it "takes a array of timestamps and a array of data" do
      time_series = TimeSeries.new(data_points.keys, data_points.values)
      time_series.length.should eql 4
    end
  end

  describe "#<<" do
    it "adds a new data point" do
      time_series << DataPoint.new(Time.now, "Knock knock")
      time_series.length.should eql 5
    end

    it "update the existing data point" do
      time_series << DataPoint.new(Time.at(1234567890), 'PARTY TIME!')
      time_series.length.should eql 4
      time_series.at(Time.at(1234567890)).should eql 'PARTY TIME!'
    end
  end

  describe "#at" do
    it "returns data associated with the given timestamp" do
      time_series.at(Time.at(1000000000)).should eql "The first Unix billennium"
    end

    it "returns data in array if two or more timestamps are given" do
      time_series.at(Time.at(1000000000), Time.at(2000000000)).should eql(
        ["The first Unix billennium", "The second Unix billennium"])
    end
  end

  describe "#slice" do
    it "returns all data points in the given timeframe" do
      ts = time_series.slice from: Time.at(1000000000), to: Time.at(2000000000)
      ts.length.should eql 3
      ts.at(Time.at 2147485547).should eql nil
    end

    it "returns all data points after the from time" do
      ts = time_series.slice from: Time.at(2000000000)
      ts.length.should eql 2
      ts.at(Time.at(1000000000), Time.at(1234567890)).should eql [nil, nil]
    end

    it "returns all data points before the to time" do
      ts = time_series.slice to: Time.at(1234567890)
      ts.length.should eql 2
      ts.at(Time.at(2000000000), Time.at(2147485547)).should eql [nil, nil]
    end
  end
end
