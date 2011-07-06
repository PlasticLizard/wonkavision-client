module Wonkavision
  class Client
    class Cellset
       class Cell
        attr_reader :cellset, :measures, :dimensions, :key
        def initialize(cellset,data = nil)
          @cellset = cellset
          @measures = {}
          if data
            @measures = data["measures"].inject({}) do |hash,measure|
              hash[measure["name"]] = Measure.new(measure)
              hash
            end
            @dimensions = data["dimensions"]
            @key = data["key"]
          end
        end

        def [](measure_name)
          measures[measure_name.to_s] || Measure.new({:name => measure_name})
        end

        def method_missing(method,*args)
          self[method]
        end

        def empty?
          measures.empty? || measures.values.detect{ |m| !m.empty? }.nil?
        end

        def filters
          unless @filters
            @filters = []
            dimensions.each_with_index do |dim_name, index|
              @filters << MemberFilter.new(dim_name, :value => key[index])
            end
            @filters += cellset.slicer
          end
          @filters
        end
      end
    end
  end
end