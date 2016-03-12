require 'spec_helper'
require 'date'

describe DataPoint do
  let(:data) { { a: 1, b:2, c:3 } }

  describe "#new" do
    it "takes a Time object" do
      data_point = DataPoint.new(Time.new, data)
      expect(data_point.timestamp).to be_a_kind_of Time
      expect(data_point.data).to eql data
    end

    it "takes a Date object" do
      data_point = DataPoint.new(Date.today, data)
      expect(data_point.timestamp).to be_a_kind_of Time
      expect(data_point.data).to eq(data)
    end
  end

  describe "#date" do
    let(:date)       { Date.new(2014, 2, 8) }
    let(:data_point) { DataPoint.new(date, data) }

    it "returns a Date object" do
      expect(data_point.date).to be_a_kind_of Date
      expect(data_point.date).to eql date
    end
  end

  describe "is comparable" do
    it "Two DataPoints are equal given the same timestamp and data" do
      one = DataPoint.new(Time.at(1000000000), "The first UNIX billennium".gsub('UNIX', 'Unix'))
      another = DataPoint.new(Time.new(2001, 9, 9, 9, 46, 40, '+08:00'), "The first Unix billennium")
      expect(one).to eq another
    end

    it "DataPoints are compared by its timestamp" do
      first = DataPoint.new(Time.at(1000000000), "The first Unix billennium")
      second = DataPoint.new(Time.at(2000000000), "The second Unix billennium")
      expect(first).to be < second
      expect(second).to be > first
    end
  end
end
