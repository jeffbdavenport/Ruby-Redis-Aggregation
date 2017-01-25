module Aggregate
  # Ensures proper arguments are passed to initialize method of a class
  class Arguments
    # Ensure args is a hash and has correct keys.
    def self.valid?(args, *valid)
      raise LOC.en.arguments.args_key if args.nil?
      raise format LOC.en.arguments.not_hash, args: args unless args.respond_to?(:keys)
      check_valid_array(args, valid)
    end

    # Fill arguments with provided conf vals
    def self.fill(args, from, *with)
      Array(with).each do |key|
        args[key.to_sym] ||= from.send(key)
      end
    end

    # Ensure arguments are valid according to list provided
    def self.check_valid_array(args, valid)
      return true if valid.empty?
      args.each_key do |key|
        raise format LOC.en.arguments.invalid_key key: key unless valid_has(valid, key)
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
