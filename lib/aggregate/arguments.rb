module Aggregate
  # Ensures proper arguments are passed to initialize method of a class
  class Arguments
    # Ensure args is a hash and has correct keys.
    def self.valid?(args)
      raise '#valid? requires a hash with the :args key' if args[:args].nil?
      unless args[:args].respond_to?(:keys)
        raise "Argument \"#{args[:args]}\", must be in hash form."
      end
      check_valid_array(args[:args], args[:valid])
    end

    def self.check_valid_array(args, valid)
      return true if valid.nil?
      args.each_key do |key|
        raise "Hash key \"#{key}\", is not a valid key" unless valid_has(valid, key)
      end
      true
    end
    private_class_method :check_valid_array

    # True if valid has or is equal to key
    def self.valid_has(valid, key)
      valid = [valid] unless valid.class == Array
      valid.include?(key.to_sym)
    end
    private_class_method :valid_has
  end
end
