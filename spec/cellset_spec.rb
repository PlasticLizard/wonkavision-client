require "spec_helper"

describe Wonkavision::Client::Cellset do
  before :each do
    response_data = eval(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'test_query_response.rb'))))
    @cellset = Wonkavision::Client::Cellset.new(response_data)
  end
  it "should extract the aggregation" do
    @cellset.aggregation.should == "Rpm::WorkQueueActivity"
  end
  it "should extract the slicer filters" do
    @cellset.slicer.length.should == 2
    @cellset.slicer.each { |s| s.should be_a_kind_of MemberFilter }
    @cellset.slicer[0].to_s.should == "dimension::context_date::key::eq::'2011-05-02'"
    @cellset.slicer[1].to_s.should == "dimension::context_date::key::gt::'2011-05-02'"
  end
  it "should extract the filters" do
    @cellset.filters.length.should == 1
    @cellset.filters[0].should be_a_kind_of MemberFilter
    @cellset.filters[0].to_s.should == "dimension::context_date::key::eq::'2011-05-02'"
  end
  it "should extract the totals cell" do
    @cellset.totals.should be_a_kind_of Wonkavision::Client::Cellset::Cell
    @cellset.totals.measures.length.should == 5
    @cellset.totals.dimensions.length.should == 0
    @cellset.totals.key.should == []
  end
  it "should extract measure names" do
    @cellset.measure_names.should == ["count", "incoming", "outgoing", "completed", "overdue"]
  end
  it "should extract the axes" do
    @cellset.axes.length.should == 1
    @cellset.axes[0].should be_a_kind_of Wonkavision::Client::Cellset::Axis
    @cellset.axes[0].dimensions.length.should == 1
  end
  it "should extract cells" do
    @cellset.cells.count.should == 1
    @cellset.cells.should be_a_kind_of Hash
    @cellset.cells.values[0].measures.length.should == 5
  end

  it "should provide a cell via an indexer" do
    @cellset["2011-05-02"].should be_a_kind_of Wonkavision::Client::Cellset::Cell
    @cellset["2011-05-02"].should_not be_empty
  end

  it "should produce an empty cell if the indexer is not found" do
    @cellset["2011-05-01"].should be_a_kind_of Wonkavision::Client::Cellset::Cell
    @cellset["2011-05-01"].should be_empty
  end
 
end