require "spec_helper"

describe Symbol do
  before :each do
    @symbol = :member
  end
  context "#key, #caption and #sort" do
    it "should produce MemberFilters of type dimension" do
      [:key,:caption,:sort].each do |method|
        filter = @symbol.send(method)
        filter.name.should == @symbol
        filter.member_type.should == :dimension
        filter.attribute_name.should == method
      end
    end
  end
  context "#sum, #sum2, #count" do
    it "should produce MemberFilters of type measure" do
      [:sum,:sum2,:count].each do |method|
        filter = @symbol.send(method)
        filter.name.should == @symbol
        filter.member_type.should == :measure
        filter.attribute_name.should == method
      end
    end
  end
 
  context "when the symbol is ':dimensions'" do
    it "should produce a MemberFilter with a dimension name as specified and a default attribute name" do
      filter = :dimensions.a_dimension
      filter.name.should == :a_dimension
      filter.attribute_name.should == :key
      filter.member_type.should == :dimension
    end
  end
  context "when the symbol is ':measures'" do
    it "should produce a MemberFilter with a measure name as specified and a default attribute name" do
      filter = :measures.a_measure
      filter.name.should == :a_measure
      filter.attribute_name.should == :count
      filter.member_type.should == :measure
    end
  end
end
