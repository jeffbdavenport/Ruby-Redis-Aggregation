module Aggregate
  # Ensures proper arguments are passed to initialize method of a class
  class Arguments
    # Ensure args is a hash and has correct keys.
    def self.valid?(args)
      raise MustHaveArgs if args[:args].nil?
      raise HashOnly, args[:args] unless args[:args].class == Hash
      check_valid_array(args[:args], args[:valid])
    end

    def self.check_valid_array(args, valid)
      return true if valid.nil?
      args.each_key do |key|
        next if valid_has(valid, key)
        raise InvalidKey, key
      end
      true
    end
    private_class_method :check_valid_array

    # True if valid has or is equal to key
    def self.valid_has(valid, key)
      return true if valid == key
      return unless valid.class == Array
      true if valid.include?(key)
    end
    private_class_method :valid_has

    # Arguments must be a Hash
    class MustHaveArgs < StandardError
      def initialize
        super '#valid? requires a hash with the :args key'
      end
    end

    # Arguments must be a Hash
    class HashOnly < StandardError
      attr_reader :args
      def initialize(args)
        @args = args
        super "Argument \"#{@args}\", must be in hash form."
      end
    end

    # Arguments hash must have specific keys
    class InvalidKey < StandardError
      attr_reader :key
      def initialize(key)
        @key = key
        super "Hash key \"#{@key}\", is not a valid key for #{@obj.class}"
      end
    end
  end
end
