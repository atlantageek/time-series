require 'spec_helper'
require 'date'

describe DataPoint do
  let(:data) { { a: 1, b:2, c:3 } }

  describe "#new" do
    it "takes a Time object" do
      data_point = DataPoint.new(Time.new, data)
      data_point.timestamp.should be_a_kind_of Time
      data_point.data.should eql data
    end

    it "takes a Date object" do
      data_point = DataPoint.new(Date.today, data)
      data_point.timestamp.should be_a_kind_of Time
      data_point.data.should eql data
    end
  end

  describe "#date" do
    let(:date)       { Date.new(2014, 2, 8) }
    let(:data_point) { DataPoint.new(date, data) }

    it "returns a Date object" do
      data_point.date.should be_a_kind_of Date
      data_point.date.should eql date
    end
  end

  describe "is comparable" do
    it "Two DataPoints are equal given the same timestamp and data" do
      one = DataPoint.new(Time.at(1000000000), "The first UNIX billennium".gsub('UNIX', 'Unix'))
      another = DataPoint.new(Time.new(2001, 9, 9, 9, 46, 40, '+08:00'), "The first Unix billennium")
      one.should eq another
    end

    it "DataPoints are compared by its timestamp" do
      first = DataPoint.new(Time.at(1000000000), "The first Unix billennium")
      second = DataPoint.new(Time.at(2000000000), "The second Unix billennium")
      first.should < second
      second.should > first
    end
  end
end
