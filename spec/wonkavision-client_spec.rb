require "spec_helper"

describe Wonkavision::Client do
  before :each do
    @client = Wonkavision::Client.new :host => "localhost",
                                      :port => 80,
                                      :secure => true,
                                      :verbose => true,
                                      :adapter => :excon
  end
  describe "initialize" do
    
    it "should take its configuration from the options" do
      @client.host.should == "localhost"
      @client.port.should == 80
      @client.secure.should be_true
      @client.verbose.should be_true
      @client.adapter.should == :excon
    end
    it "should initialize a Faraday connection appropriately" do
      @client.connection.should_not be_nil
      @client.connection.should be_a_kind_of Faraday::Connection
    end
  end

  describe "get" do
    it "should delegate the request to the connection" do
      @client.connection.should_receive("get").with("a/b").and_return(mock(:response, :body => nil))
      @client.get("a/b")
    end
    it "should decode the response as json" do
      @client.connection.should_receive("get").with("a/b").and_return(mock(:response, :body => Yajl::Encoder.encode({"a"=>"b"})))
      @client.get("a/b").should be_a_kind_of Hash
    end
    it "should return the raw response when requested" do
      @client.connection.should_receive("get").with("a/b").and_return(mock(:response, :body => Yajl::Encoder.encode({"a"=>"b"})))
      @client.get("a/b",:raw=>true).should == Yajl::Encoder.encode({"a"=>"b"})
    end
  end

  describe "submit_event" do
    it "should construct a url and submit the event data as a json payload" do
      @client.connection.should_receive(:post).with("/events/tada/hi", {:my=>:friend}, 'Content-Type' => 'application/json')
      @client.submit_event("tada/hi", {:my=>:friend})  
    end
  end

  it "should format a url according to secure, host and port" do
    @client.url.should == "https://localhost:80"
  end

  it "should decode json" do
    @client.decode(Yajl::Encoder.encode({"a"=>"b"})).should == {"a"=>"b"}  
  end

  describe "prepare_filters" do
    it "should include global filers" do
      Wonkavision::Client.context.filter :hi => 3
      @client.send(:prepare_filters, [:dimensions.ho.eq(1)]).should == [:dimensions.ho.eq(1), :dimensions.hi.eq(3)].map{|f|f.to_s}.join("|")
    end
  end
end