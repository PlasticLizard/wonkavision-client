module Wonkavision
  class Client
    class Cellset
      class Axis
        attr_reader :dimensions, :cellset, :members, :start_index, :end_index
        def initialize(cellset, data, start_index)
          @members = {}
          @cellset = cellset
          @dimensions = data["dimensions"].map do |dimension|
            Dimension.new(self, dimension)
          end
          @start_index = start_index
          @end_index = @start_index + @dimensions.length - 1
        end
        def dimension_names
          dimensions.map(&:name)
        end
        def [](*coordinates)
          cell_key = coordinates.flatten.compact.map{ |c|c.nil? ? nil : c.to_s}
          members[cell_key] ||=  MemberInfo.new(self,cell_key)
        end

        private

        class MemberInfo

          attr_reader :axis, :key
          def initialize(axis,cell_key)
            @axis = axis
            @key = cell_key
          end

          def totals
            cell_key = Array.new(axis.start_index) + key
            cell = axis.cellset[cell_key]
          end

          def descendent_count(include_empty=false)
            return descendent_keys.length if include_empty
            @descendent_count ||= descendent_keys.reject{ |k| axis[k].empty? }.length
          end

          def descendent_keys
            cell_key = Array.new(axis.start_index) + key
            @descendent_keys ||= axis.cellset.cells.keys.select do |k|
              k.length > cell_key.length &&
                k.length <= axis.end_index + 1 &&
                k[0..cell_key.length-1] == cell_key
            end
          end

          def empty?
            totals.empty?
          end
        
        end
      end
    end
  end
end
