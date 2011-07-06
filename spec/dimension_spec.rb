require "spec_helper"

describe Wonkavision::Client::Cellset::Dimension do
  before :each do
    response_data = eval(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'test_query_response.rb'))))
    @cellset = Wonkavision::Client::Cellset.new(response_data)
    @dimension = @cellset.axes[0].dimensions[0]
  end
  it "should extract the name" do
    @dimension.name.should == "context_date"
  end
  it "should extract members" do
    @dimension.members.length.should == 1
    @dimension.members[0].should be_a_kind_of Wonkavision::Client::Cellset::Member
  end
end