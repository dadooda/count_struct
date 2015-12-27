
# The <tt>Struct</tt>-like metaclass for counting.
#
#   count = CountStruct.new(:cats, :dogs).new
#   >> count.cats
#   => 0
#   >> count.cats += 1
#   >> count.dogs += 3
#   >> count.to_h
#   => {:cats=>1, :dogs=>3, :total=>4}
#   >> count.dogs = 0
#   >> count.to_h
#   => {:cats=>1, :dogs=>0, :total=>1}
#
# Using in a class:
#
#   class AnimalReport
#     Count = CountStruct.new(:cats, :dogs)      # Use a regular constant for the class. DO NOT use `class Count < ...` due to superclass mismatch error.
#
#     def add_cat(cat)
#       count.cats += 1
#       ...
#     end
#
#     def add_dog(dog)
#       count.dogs += 1
#       ...
#     end
#
#     def count
#       @count ||= Count.new
#     end
#   end
class CountStruct
  require "count_struct/no_total"

  def self.new(*keys)
    raise ArgumentError, "At least one key is required" if keys.empty?
    raise ArgumentError, "Key 'total' is not allowed" if keys.map(&:to_s).include? "total"

    klass = Class.new

    klass.class_exec(keys) do |keys|
      keys.each do |k|
        eval %{
          def #{k}
            @#{k} ||= 0
          end

          def #{k}=(value)
            @#{k} = value
          end
        }
      end

      eval "def clear; " + keys.map {|k| "remove_instance_variable :@#{k}"}.join("; ") + "; end"

      # Build something like: `"#<count cats=#{send(:cats)} dogs=#{send(:dogs)} | total=#{total}>"`.
      eval 'def inspect; "#<count ' + keys.map {|k| "#{k}=\#{send(:#{k})}"}.join(" ") + ' | total=#{total}>"; end'

      # Build something like: `{cats: send(:cats), dogs: send(:dogs), total: send(:total), ...}`.
      eval "def to_h; {" + (keys + [:total]).map {|k| "#{k}: send(:#{k})"}.join(", ") + "}; end"

      def to_s
        inspect
      end

      # Build something like: `send(:cats) + send(:dogs)`.
      eval "def total; " + keys.map {|k| "send(:#{k})"}.join(" + ") + "; end"
    end # class_exec

    klass
  end
end

#
# Implementation notes:
#
# * Attributes *can* be named as keywords. E.g. `in`.
#   To tackle this we use `send()` where the value is required.
#