require "spec_helper"

describe Wonkavision::Client::Facts do
  before :each do
    @client = Wonkavision::Client.new :host => "localhost",
                                      :port => 80,
                                      :secure => true,
                                      :verbose => true,
                                      :adapter => :excon
    @facts = @client.facts("TestFacts")
  end

  describe "purge!" do
    it "should call get on the client with an appropriate url" do
      @client.should_receive(:get).with("admin/facts/TestFacts/purge").and_return
      @facts.purge!
    end
  end
  
end