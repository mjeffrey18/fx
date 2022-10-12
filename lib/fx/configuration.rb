module Fx
  # @return [Fx::Configuration] F(x)'s current configuration
  def self.configuration
    @_configuration ||= Configuration.new
  end

  # Set F(x)'s configuration
  #
  # @param config [Fx::Configuration]
  def self.configuration=(config)
    @_configuration = config
  end

  # Modify F(x)'s current configuration
  #
  # @yieldparam [Fx::Configuration] config current F(x) config
  # ```
  # Fx.configure do |config|
  #   config.database = Fx::Adapters::Postgres
  #   config.dump_functions_at_beginning_of_schema = true
  # end
  # ```
  def self.configure
    yield configuration
  end

  # F(x)'s configuration object.
  class Configuration
    # The F(x) database adapter instance to use when executing SQL.
    #
    # Defaults to an instance of {Fx::Adapters::Postgres}
    # @return Fx adapter
    attr_accessor :database

    # Prioritizes the order in the schema.rb of functions before other
    # statements in order to make directly schema load work when using functions
    # in statements below, i.e.: default column values.
    #
    # Defaults to false
    # @return Boolean
    attr_accessor :dump_functions_at_beginning_of_schema

    # disable schema dumping functions
    # Defaults to false
    # @return Boolean
    attr_accessor :disable_functions_dump

    # disable schema dumping triggers
    # Defaults to false
    # @return Boolean
    attr_accessor :disable_triggers_dump

    # disable certain triggers from being schema dumped
    # Defaults to []
    # @return [String]
    attr_accessor :only_dump_these_triggers

    # disable certain functions from being schema dumped
    # Defaults to []
    # @return [String]
    attr_accessor :only_dump_these_functions

    def initialize
      @database = Fx::Adapters::Postgres.new
      @dump_functions_at_beginning_of_schema = false
      @disable_functions_dump = false
      @disable_triggers_dump = false
      @only_dump_these_triggers = []
      @only_dump_these_functions = []
    end
  end
end
