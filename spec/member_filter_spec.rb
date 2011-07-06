require "spec_helper"
require "cgi"

MemberFilter = Wonkavision::Client::MemberFilter

describe "MemberFilter" do
  before :each do
    @dimension = MemberFilter.new(:a_dim,   :member_type=>:dimension)
    @measure = MemberFilter.new(:a_measure, :member_type=>:measure)
  end
  context "#attribute_name" do
    it "should default to key for dimension" do
      @dimension.attribute_name.should == :key
    end
    it "should default to count for measure" do
      @measure.attribute_name.should == :count
    end
  end
  context "#dimension?" do
    it "should be true for dimension" do
      @dimension.dimension?.should be_true
    end
    it "should not be true for measure" do
      @measure.dimension?.should_not be_true
    end
  end
  context "#measure?" do
    it "should be true for measure" do
      @measure.measure?.should be_true
    end
    it "should not be true for dimension" do
      @dimension.measure?.should_not be_true
    end
  end
  context "#operators" do
    it "should set the operator property appropriately" do
      [:gt, :lt, :gte, :lte, :ne, :in, :nin].each do |op|
        @dimension.send(op).operator.should == op
      end
    end
  end

  context "#to_s" do
    it "should produce a canonical string representation of a member filter" do
      filter = MemberFilter.new(:hi).eq(3)
      filter.to_s.should == "dimension::hi::key::eq::3"
    end
    it "should be 'parse'able to reproduce the filter" do
      filter = MemberFilter.new(:hi).eq(3)
      filter2 = MemberFilter.parse(filter.to_s)
      filter2.should == filter
    end
    it "should wrap strings in a single quote" do
      filter = MemberFilter.new(:hi).ne("whatever")
      filter.to_s.should == "dimension::hi::key::ne::'whatever'"
    end
    it "should be able to represent a parseable time as a filter value" do
      filter = MemberFilter.new(:hi).gt(Time.now)
      filter2 = MemberFilter.parse(filter.to_s)
      filter2.should == filter
    end
    it "should omit the value portion of the string when requested" do
      filter = MemberFilter.new(:hi).gt(5)
      filter.to_s(:exclude_value=>true).should == "dimension::hi::key::gt"
    end
    it "should be able to parse a value-less emission" do
      filter = MemberFilter.new(:hi).gt(5)
      filter2 = MemberFilter.parse(filter.to_s(:exclude_value=>true))
      filter2.value.should be_nil
      filter2.value = 5
      filter2.should == filter
    end
    it "should take its value from an option on parse" do
      filter = MemberFilter.new(:hi).gt(5)
      filter2 = MemberFilter.parse(filter.to_s(:exclude_value=>true),
                                                           :value=>5)
      filter2.should == filter
    end
    it "should return just a name with name_only is true" do
      filter = MemberFilter.new(:hi)
      filter.to_s(:name_only=>true).should == "dimension::hi::key"
      filter.to_s(:name_only=>true).should == filter.qualified_name
    end

  end


end
