module Wonkavision
  class Client
    class Query
      LIST_DELIMITER = "|"

      attr_reader :axes, :filters, :client

      def initialize(client, options = {})
        @client = client
        @axes = []
        @filters = []
        @measures = []
      end

      def from(aggregation_name=nil)
        return @from unless aggregation_name
        @from = aggregation_name
        self
      end

      def select(*dimensions)
        options = dimensions.last.is_a?(::Hash) ? dimensions.pop : {}
        axis = options[:axis] || options[:on]
        axis_ordinal = self.class.axis_ordinal(axis)
        @axes[axis_ordinal] = dimensions
        self
      end
     
      def measures(*measures)
        return @measures if measures.length < 1
        @measures.concat measures.flatten
        self
      end

      def where(criteria_hash = {})
        criteria_hash.each_pair do |filter,value|
          member_filter = filter.kind_of?(MemberFilter) ? filter :
            MemberFilter.new(filter)
          member_filter.value = value
          @filters << member_filter
        end
        self
      end  

      def validate!
        raise "You forgot to specify a source aggregation. Please call 'from(my_aggregation) prior to execute." unless @from
        axes.each_with_index{|axis,index|raise "Axes must be selected from in consecutive order and contain at least one dimension. Axis #{index} is blank." if axis.empty?}
        self
      end 

      def to_h
        self.to_params.merge!("from" => from)
      end

      def to_params
        query = {}
        query["measures"] = @measures.join(LIST_DELIMITER) if @measures.length > 0
        query["filters"] = @client.prepare_filters(@filters) if filters.length > 0
        axes.each_with_index do |axis, index|
          query[self.class.axis_name(index)] = axis.map{|dim|dim.to_s}.join(LIST_DELIMITER)
        end
        query
      end

      def to_s
        to_h.inspect
      end

      def execute(opts={})
        raw = opts[:raw]
        validate!
        cellset_data = @client.get("query/#{@from}", self.to_params.merge!(opts))
        raw ? cellset_data : Cellset.new(cellset_data)  
      end

      def self.axis_names
        ["columns","rows","pages","chapters","sections"]
      end
      
      #add methods for each axis
      #ex: Query.new.columns("col a", "col b").rows("col c", "col d")
      self.axis_names.each do |axis|
        eval "def #{axis}(*args);add_options(args, :axis=>#{axis.inspect});select(*args);end"
      end

      def self.axis_ordinal(axis_def)
        axis_name = axis_def.to_s.strip.downcase.to_s
        axis_names.index(axis_name) || axis_def.to_i
      end

      def self.axis_name(axis_ordinal)
        axis_names[axis_ordinal]
      end
      
      private
      def add_options(args, new_options)
        opts = args.last.is_a?(::Hash) ? args.pop : {}
        opts.merge!(new_options)
        args.push opts
        self
      end

      

    end
  end
end