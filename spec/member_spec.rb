require "spec_helper"

describe Wonkavision::Client::Cellset::Member do
  before :each do
    response_data = eval(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'test_query_response.rb'))))
    @cellset = Wonkavision::Client::Cellset.new(response_data)
    @member = @cellset.axes[0].dimensions[0].members[0]
  end
  it "should extract the name" do
    @member.key.should == "2011-05-02"  
  end
  it "should extract the caption or use the name" do
    @member.caption.should == "2011-05-02"
  end
end