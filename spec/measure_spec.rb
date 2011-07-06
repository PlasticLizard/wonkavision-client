require "spec_helper"

describe Wonkavision::Client::Cellset::Measure do
  before :each do
    response_data = eval(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'test_query_response.rb'))))
    @cellset = Wonkavision::Client::Cellset.new(response_data)
    @measure = @cellset["2011-05-02"].measures["completed"]
  end
  it "should extract the name" do
    @measure.name.should == "completed"
    @measure.value.should == 0
    @measure.formatted_value.should == "0"
  end
end