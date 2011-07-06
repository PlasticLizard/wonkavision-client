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
      end
     
    end
  end
end