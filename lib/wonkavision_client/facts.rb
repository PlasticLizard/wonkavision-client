module Wonkavision
  class Client
    class Facts

      attr_reader :client, :name
      def initialize(client, name)
        @client = client
        @name = name
      end

      def purge!
        @client.get("admin/facts/#{@name}/purge")    
      end
      
    end
  end
end