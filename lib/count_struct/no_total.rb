
require File.expand_path("../../count_struct", __FILE__)

class CountStruct
  # A basic version of {CountStruct} without the total count.
  #
  # @see CountStruct
  class NoTotal
    def self.new(*keys)
      raise ArgumentError, "At least one key is required" if keys.empty?
      raise ArgumentError, "Key 'total' is not allowed" if keys.map(&:to_s).include? "total"

      klass = Class.new

      klass.class_exec(keys) do |keys|
        attr_accessor *keys

        keys.each do |k|
          eval "def #{k}; @#{k} ||= 0; end"
        end

        eval "def clear; " + keys.map {|k| "remove_instance_variable :@#{k}"}.join("; ") + "; end"

        # Build something like: `"#<count cats=#{send(:cats)} dogs=#{send(:dogs)}>"`.
        eval 'def inspect; "#<count ' + keys.map {|k| "#{k}=\#{send(:#{k})}"}.join(" ") + '>"; end'

        # Build something like: `{cats: send(:cats), dogs: send(:dogs), total: send(:total), ...}`.
        eval "def to_h; {" + keys.map {|k| "#{k}: send(:#{k})"}.join(", ") + "}; end"

        def to_s
          inspect
        end
      end # class_exec

      klass
    end
  end
end
