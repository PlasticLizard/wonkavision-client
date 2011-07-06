require "spec_helper"

describe Wonkavision::Client::Cellset::Cell do
  before :each do
    response_data = eval(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'test_query_response.rb'))))
    @cellset = Wonkavision::Client::Cellset.new(response_data)
    @cell = @cellset["2011-05-02"]
  end

  it "should extract measures" do
    @cell.measures.values[0].should be_a_kind_of Wonkavision::Client::Cellset::Measure
    @cell.dimensions.should == ["context_date"]
    @cell.key.should == ["2011-05-02"]
  end

  it "should return empty if no data is provided" do
    Wonkavision::Client::Cellset::Cell.new(@cellset, nil).should be_empty
  end

  it "should provide access to measures via an indexer" do
    @cell["count"].should be_a_kind_of Wonkavision::Client::Cellset::Measure
  end

  it "should delegate method missing to the indexer" do
    @cell.count.should == @cell["count"]
  end

  it "should compose a list of filters to describe the cell" do
    @cell.filters[0].should == :dimensions.context_date.eq("2011-05-02")
  end

  it "should include the query slicer in the filter list" do
    @cell.filters[1..-1].should == @cellset.slicer
  end


  
end