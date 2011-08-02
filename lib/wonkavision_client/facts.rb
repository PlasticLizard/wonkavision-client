require "time"

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

      def take_snapshot!(snapshot_name, snapshot_time = nil)
        #default to end of day yesterday 
        snapshot_time ||= (Time.parse("#{Time.now.iso8601[0..9]}T00:00:00") - 1).iso8601
        @client.get("admin/facts/#{@name}/snapshots/#{snapshot_name}/take/#{snapshot_time}")
      end

      def calculate_stats!(snapshot_name, snapshot_time = nil)
        #default to end of day yesterday 
        snapshot_time ||= (Time.parse("#{Time.now.iso8601[0..9]}T00:00:00") - 1).iso8601
        @client.get("admin/facts/#{@name}/snapshots/#{snapshot_name}/calculate_stats/#{snapshot_time}")
      end
      
    end
  end
end