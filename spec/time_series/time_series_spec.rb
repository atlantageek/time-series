require 'spec_helper'

describe TimeSeries do
  let(:time_series) { TimeSeries.new }
  let(:timestamp)   { Time.now }
  let(:data)        { { a: 1, b:2, c:3 } }

  before { time_series << DataPoint.new(timestamp, data) }

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
