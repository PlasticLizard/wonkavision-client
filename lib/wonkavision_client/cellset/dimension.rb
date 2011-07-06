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

        def non_empty?(*parents)
          member.reject { |mem| is_empty?(mem, *parents) }
        end

        def is_empty?(member, *parent)
          key = parents.dup << member.key
          axis[key].empty?
        end
        
      end

    end
  end
end