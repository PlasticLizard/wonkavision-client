module Wonkavision
  class Client
    class Cellset
      
      class Member
        attr_reader :key, :caption, :attributes
        def initialize(data)
          @key = data["key"]
          @caption = data["caption"] || @key
          @attributes = data["attributes"] || {}
        end

        def to_s
          key.to_s
        end

        def to_key
          key
        end
      end
     
    end
  end
end