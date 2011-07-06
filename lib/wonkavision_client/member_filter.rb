require "time"

module Wonkavision
  class Client
    class MemberFilter
      include Comparable

      attr_reader :name, :operator, :member_type
      attr_accessor :value

      def initialize(member_name, options={})
        @name = member_name
        @attribute_name = options[:attribute_name]
        @operator = options[:operator] || options[:op] || :eq
        @member_type = options[:member_type] || :dimension
        @value = options[:value]
        @applied = false
      end

      def attribute_name
        @attribute_name ||= dimension? ? :key : :count
      end

      def dimension?
        member_type == :dimension
      end

      def measure?
        member_type == :measure
      end

      def delimited_value(for_eval=false)
        case value
        when nil then "nil"
        when String, Symbol then "'#{value}'"
        when Time then for_eval ? "Time.parse('#{value}')" : "time(#{value})"
        else value.inspect
        end
      end

      def to_s(options={})
        properties = [member_type,name,attribute_name,operator,delimited_value]
        properties.pop if options[:exclude_value] || options[:name_only]
        properties.pop if options[:name_only]

        properties.join("::")
      end

      def self.parse(filter_string,options={})
        new(nil).parse(filter_string,options)
      end

      def parse(filter_string,options={})
        parts = filter_string.split("::")
        @member_type = parts.shift.to_sym
        @name = parts.shift
        @attribute_name = parts.shift
        @operator = parts.shift.to_sym
        @value = parse_value(options[:value] || parts.shift || @value)
        self
      end

      def inspect
        to_s
      end

      def qualified_name
        to_s(:name_only=>true)
      end

      def <=>(other)
        inspect <=> other.inspect
      end

      def ==(other)
        inspect == other.inspect
      end

      [:gt, :lt, :gte, :lte, :ne, :in, :nin, :eq].each do |operator|
        define_method(operator) do |*args|
          @value = args[0] if args.length > 0
          @operator = operator; self
        end unless method_defined?(operator)
      end

      def method_missing(sym,*args)
        super unless args.empty?
        @attribute_name = sym
        self
      end
      

    private

    def parse_value(value_string)
      case value_string
      when /^\'.*\'$/ then value_string[1..-2]
      when /^time\(.*\)$/ then Time.parse(value_string[5..-2])
      when String then value_string.is_numeric? ? eval(value_string) : value_string
      else value_string
      end
    end

    end
  end
end
