require "spec_helper"

describe Wonkavision::Client::Aggregation do
  before :each do
    @client = Wonkavision::Client.new :host => "localhost",
                                      :port => 80,
                                      :secure => true,
                                      :verbose => true,
                                      :adapter => :excon
    @aggregation = @client.aggregation("TestAggregation")
    Wonkavision::Client.context.global_filters.clear()
  end

  describe "query" do
    describe "when a block is given that takes a parameter" do
      it "should yield the query to the block" do
        @aggregation.query do |q|
          q.should be_a_kind_of(Wonkavision::Client::Query)
        end.should be_a_kind_of Wonkavision::Client::Query
      end
    end
    describe "when a block is given with no arity" do
      it "should instance eval the block against the query" do
        q = @aggregation.query do
          columns :a
        end
        q.should be_a_kind_of Wonkavision::Client::Query
        q.axes[0].should == [:a]
      end
    end
    describe "when no block is given" do
      it "should just return the query" do
        @aggregation.query.should be_a_kind_of Wonkavision::Client::Query
      end
    end
  end

  describe "facts" do
    it "should merge provided filters into the options hash" do
      @client.should_receive("get").with("facts/TestAggregation", {"filters" => "dimension::a::key::eq::'b'|dimension::c::key::eq::'d'", :page => 1})
      @aggregation.facts([:dimensions.a.eq("b"), :dimensions.c.eq("d")], :page => 1)
    end
    it "should prepare an appropriate url from the aggregation name" do
      @client.should_receive("get").with("facts/TestAggregation", {})
      @aggregation.facts(nil)
    end
    it "should paginate facts if pagination info is returned" do
      @client.should_receive("get").and_return "data" => [1,2,3],
                                               "pagination" => {
                                                  "total_entries" => 3,
                                                  "per_page" => 1,
                                                  "current_page" => 2
                                                }
      results = @aggregation.facts(nil)["data"]
      results.total_entries.should == 3
      results.per_page.should == 1
      results.current_page.should == 2
    end
  end
 
end