require "spec_helper"
Query = Wonkavision::Client::Query

describe Wonkavision::Client::Query do
  before :each do
    @client = mock(:client)
    @query = Query.new(@client)
  end

  describe "class methods" do
    describe "axis_ordinal" do
      it "should convert nil or empty string to axis zero" do
        Query.axis_ordinal(nil).should == 0
        Query.axis_ordinal("").should == 0
      end
      it "should convert string integers into real integers" do
        Query.axis_ordinal("3").should == 3
      end
      it "should correctly interpret named axes" do
        ["Columns", :rows, :PAGES, "chapters", "SECTIONS"].each_with_index do |item,idx|
        Query.axis_ordinal(item).should == idx
        end
      end
    end
  end

  describe "select" do
    it "should associate dimensions with the default axis (columns)" do
        @query.select :hi, :there
        @query.axes[0].should == [:hi, :there]
    end
    it "should associate dimensions with the specified axis" do
      @query.select :hi, :there, :on => :rows
      @query.axes[1].should == [:hi, :there]
    end
    it "should proxy to select with an appropiate axis-method" do
      Query.axis_names.each_with_index do |axis_name, ordinal|
        @query.send(axis_name, :hi, :there)
        @query.axes[ordinal].should == [:hi,:there]
      end
    end
  end

  describe "where" do
    it "should convert a symbol to a MemberFilter" do
      @query.where :a=>:b
      @query.filters[0].should be_a_kind_of Wonkavision::Client::MemberFilter
    end

    it "should append filters to the filters array" do
      @query.where :a=>:b, :c=>:d
      @query.filters.length.should == 2
    end

    it "should set the member filters value from the hash" do
      @query.where :a=>:b
      @query.filters[0].value.should == :b
    end   
  end

  describe "from" do
    it "should set and read the from aggregation" do
      @query.from "Abc"
      @query.from.should == "Abc"
    end
  end

  describe "measures" do
    it "should set and read measures" do
      @query.measures("a","b","c")
      @query.measures.should == ["a","b","c"]
    end
  end

  describe "to_h" do
    before :each do 
      @query.from "the top"
      @query.measures "a","b","c"
      @query.where :dimensions.a => "d"
      @query.columns "e"
      @query.rows "f","g"
      @hash = @query.to_h
    end
    it "should include the from aggregation" do
      @hash["from"].should == "the top"
    end
    it "should include measures" do
      @hash["measures"].should == "a,b,c"
    end
    it "Should include filters" do
      @hash["filters"].should == "dimension::a::key::eq::'d'"
    end
    it "should include specified axes" do
      @hash["columns"].should == "e"
      @hash["rows"].should == "f,g"
    end
    it "should not include non-specified axes" do
      Query.axis_names[2..-1].each do |axis_name|
        @hash.keys.should_not include axis_name
      end
    end
  end

  describe "to_s" do
    it "should inspect the results of to_h" do
      @query.to_s.should == @query.to_h.inspect
    end
  end

  describe "execute" do
    it "should validate the query" do
      @query.should_receive(:validate!).and_return
      @client.stub(:get => {})
      @query.execute
    end
    it "should call get on the client with an appropriate url and params" do
      @query.stub(:validate!).and_return
      @client.should_receive("get").with("query/me",{"columns"=>"a"}).and_return({})
      @query.columns "a"
      @query.from "me"
      @query.execute
    end
    it "should wrap the results in a cellset" do
      @query.stub(:validate!).and_return
      @client.should_receive("get").with("query/me",{"columns"=>"a"}).and_return({})
      @query.columns "a"
      @query.from "me"
      @query.execute.should be_a_kind_of Wonkavision::Client::Cellset
    end
    it "should return raw json when 'raw' is an option" do
      @query.stub(:validate!).and_return
      @client.should_receive("get").with("query/me",{:raw => true, "columns"=>"a"}).and_return("pretend this is json")
      @query.columns "a"
      @query.from "me"
      @query.execute(:raw => true).should == "pretend this is json"
    end
  end

  describe "prepare_filters" do
    it "should include global filers" do
      Wonkavision::Client.context.filter :hi => 3
      @query.where :ho => 1
      @query.send(:prepare_filters).should == [:dimensions.ho.eq(1), :dimensions.hi.eq(3)]
    end
  end
end