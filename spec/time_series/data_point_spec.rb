require 'spec_helper'

describe DataPoint do
  let(:data) { { a: 1, b:2, c:3 } }

  describe "#new" do
    it "takes a Time object" do
      data_point = DataPoint.new(Time.new, data)
      data_point.timestamp.should be_a_kind_of Time
      data_point.data.should eql data
    end
  end
end
