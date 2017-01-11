require 'yaml'

module Aggregate
  # Load locale from yml file into Object.
  class Locale
    def initialize(args = {})
      Arguments.valid? args: args, valid: [:file, :hash]
      file = args[:file]
      hash = if args[:file].nil?
               args[:hash]
             else
               YAML.load_file file
             end
      @hash = {}
      add_methods_for_keys hash
    end

    # Go through each hash element and define keys as methods
    def add_methods_for_keys(hash)
      hash.each do |key, val|
        @hash[key] = val.class == Hash ? Locale.new(hash: val) : val
        add_method key
      end
    end

    # Define keythod for key
    def add_method(key)
      self.class.send(:define_method, key) do
        @hash[key]
      end
    end
  end
end
