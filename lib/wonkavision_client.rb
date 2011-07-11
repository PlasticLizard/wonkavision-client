require "rubygems"
require "bundler"
Bundler.setup(:default)
require "faraday"
require "yajl"

require "wonkavision_client/version"
require "wonkavision_client/context"
require "wonkavision_client/extensions"
require "wonkavision_client/member_filter"
require "wonkavision_client/query"
require "wonkavision_client/cellset/cell"
require "wonkavision_client/cellset/axis"
require "wonkavision_client/cellset/measure"
require "wonkavision_client/cellset/dimension"
require "wonkavision_client/cellset/member"
require "wonkavision_client/cellset"
require "wonkavision_client/paginated"

module Wonkavision
  class Client
    attr_accessor :host, :port, :secure
    attr_reader :verbose, :connection, :adapter

    def initialize(options={})
      @host = options[:host] || "127.0.0.1"
      @port = options[:port] || 9000
      @secure = options[:secure] || options[:ssl]
      @verbose = options[:verbose] || false
      @adapter = options[:adapter] || Faraday.default_adapter

      @connection = Faraday.new(:url => self.url) do |builder|
        builder.request :url_encoded
        builder.response :logger if @verbose
        builder.adapter @adapter
      end
    end

    def url
      scheme = self.secure ? "https" : "http"
      "#{scheme}://#{host}:#{port}"
    end

    def query(options = {}, &block)
      new_query = Query.new(self, options)
      if block_given?
        if block.arity > 0
          yield new_query
        else
          new_query.instance_eval(&block)
        end
      end
      new_query
    end

    def facts(aggregation_name, filters, options ={})
      params = options.dup
      params["filters"] = filters.map{ |f| f.to_s }.join(",") if filters
      facts = get("facts/#{aggregation_name}", params)
      if facts && facts["pagination"]
        Paginated.apply(facts["data"], facts["pagination"])    
      end
      facts
    end

    #http methods
    def self.default_adapter
      Faraday.default_adapter
    end

    def self.default_adapter=(new_adapter)
      Faraday.default_adapter = new_adapter
    end

    def get(path, parameters={})
      raw = parameters.delete(:raw)
      response = @connection.get(path) do |r|
        r.params.update parameters
        r.headers['Accept'] = 'application/json'    
      end

      raw ? response.body : decode(response.body)
    end

    #helpers
    def decode(json = nil)
      json ? Yajl::Parser.new.parse(json) : {}
    end

  end
end
