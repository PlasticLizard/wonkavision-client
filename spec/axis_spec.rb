require "spec_helper"

describe Wonkavision::Client::Cellset::Axis do
  before :each do
    response_data = eval(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'test_query_response.rb'))))
    @cellset = Wonkavision::Client::Cellset.new(response_data)
    @axis = @cellset.axes[0]
  end

  it "should extract the dimensions" do
    @axis.dimensions.length.should == 1
    @axis.dimensions[0].should be_a_kind_of Wonkavision::Client::Cellset::Dimension
  end
  it "should provide a list of dimension names" do
    @axis.dimension_names.should == ["context_date"]
  end
  context "#[]" do
    before :each do
      @cell = @axis["2011-05-02"]
    end
    it "should locate a totals cell for the given coordinates" do
      @cell.should_not be_nil
      @cell.should_not be_empty
    end
    it "should locate a cell with an abbreviated key matching just the axis coords" do
      @cell.key.should == ["2011-05-02"]
    end
    it "should locate a cell with correctly specified dimensions" do
      @cell.totals.dimensions.should == ["context_date"]
    end
    it "should aggregate all detail for the given summary cell" do
      @cell.totals.measures["count"].value.should == 1
    end     
  end
  
end