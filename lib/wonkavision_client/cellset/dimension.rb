module Wonkavision
  class Client
    class Cellset

      class Dimension
        attr_reader :name, :members, :axis
        def initialize(axis, data)
          @axis = axis
          @name = data["name"]
          @members = data["members"].map do |member|
            Member.new(member)
          end
        end

        def non_empty(*parents)
          members.reject { |mem| is_empty?(mem, *parents) }
        end

        def is_empty?(member, *parents)
          key = parents.dup << member.key
          axis[key].empty?
        end

        def position
          axis.dimensions.index(self)
        end

        def next_dimension
          axis.dimensions[position+1]
        end

        def previous_dimension
          axis.dimensions[position-1]
        end

        def root?
          !previous_dimension
        end

        def leaf?
          !next_dimension
        end
        
      end

    end
  end
end