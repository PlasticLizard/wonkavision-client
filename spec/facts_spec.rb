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

  #ex admin/facts/WorkQueueEntryFacts/snapshots/daily/take/2011-07-21
  describe "take_snapshot!" do
    it "should call get on the client with an appropriate url" do
      @client.should_receive(:get).with("admin/facts/TestFacts/snapshots/daily/take/2011-07-20")
      @facts.take_snapshot!(:daily, "2011-07-20")
    end
    it "should default the snapshot time to the end of yesterday" do
      today = Time.parse("#{Time.now.localtime.iso8601[0..9]}T00:00:00") - 1
      @client.should_receive(:get).with("admin/facts/TestFacts/snapshots/daily/take/#{today.iso8601}")
      @facts.take_snapshot! :daily
    end
  end
  
end