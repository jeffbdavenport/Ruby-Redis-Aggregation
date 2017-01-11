module Aggregate
  # Ensures proper arguments are passed to initialize method of a class
  class Arguments
    # Ensure args is a hash and has correct keys.
    def self.validate(obj, args, *valid_keys)
      throw LOC.arguments.hash_only % { args: args } unless args.class == Hash
      args.each_key do |key|
        next if valid_keys.include?(key)
        throw LOC.arguments.invalid_key % { key: key, class: obj.class }
      end
    end
  end
end
