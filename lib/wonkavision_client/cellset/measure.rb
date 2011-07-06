module Wonkavision
  class Client
    class Cellset
      class Measure
        attr_reader :name, :formatted_value, :value, :calculated
        def initialize(data)
          @name = data["name"]
          @value = data["value"]
          @formatted_value = data["formatted_value"] || @value.to_s
          @calculated = data["calculated"] || false
        end

        def empty?
          @value.nil?
        end

        def to_s
          formatted_value
        end
      end
    end
  end
end