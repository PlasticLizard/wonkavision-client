module Wonkavision
  class Client
    class Cellset
      attr_reader :aggregation, :slicer, :filters, :totals,
                  :measure_names, :axes, :cells

      def initialize(cellset_data = {})
        @aggregation = cellset_data["aggregation"] || nil
        @slicer = parse_filters cellset_data["slicer"] || []
        @filters = parse_filters cellset_data["filters"]
        @totals = Cell.new(self, cellset_data["totals"])
        @measure_names = cellset_data["measure_names"] || []
        start_index = 0
        @axes = (cellset_data["axes"] || []).map do |axis|
          Axis.new(self, axis, start_index).tap do |a|
            start_index = a.end_index + 1
          end
        end
        @cells = (cellset_data["cells"] || []).inject({}) do |hash, cell|
          hash[cell["key"]] = Cell.new(self,cell)
          hash
        end
      end

      def columns; axes[0]; end
      def rows; axes[1]; end
      def pages; axex[2]; end
      def chapters; axes[3]; end
      def sections; axes[4]; end

      def [](*coordinates)
        coordinates.flatten!
        key = coordinates.map{ |c|c.nil? ? nil : c.to_s }
        @cells[key] || Cell.new(self)
      end

      private
      def parse_filters(filters)
        filters ? filters.map{ |f| Wonkavision::Client::MemberFilter.parse(f) } : []
      end
    end
  end
end