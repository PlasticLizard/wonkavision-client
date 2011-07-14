module Wonkavision
  class Client
    class Aggregation

      attr_reader :client, :name
      
      def initialize(client, name)
        @client = client
        @name = name
      end

      def query(options = {}, &block)
        new_query = Query.new(self, options)
        new_query.from(@name)
        if block_given?
          if block.arity > 0
            yield new_query
          else
            new_query.instance_eval(&block)
          end
        end
        new_query
      end

      def facts(filters, options={})
        params = options.dup
        params["filters"] = @client.prepare_filters(filters) if filters
        facts = @client.get("facts/#{@name}", params)
        if facts && facts["pagination"]
          Paginated.apply(facts["data"], facts["pagination"])    
        end
        facts
      end

    end
  end
end