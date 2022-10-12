require "rails"

module Fx
  module SchemaDumper
    # @api private
    module Function
      def tables(stream)
        if Fx.configuration.dump_functions_at_beginning_of_schema
          functions(stream)
          empty_line(stream)
        end

        super

        unless Fx.configuration.dump_functions_at_beginning_of_schema
          functions(stream)
          empty_line(stream)
        end
      end

      def empty_line(stream)
        stream.puts if dumpable_functions_in_database.any?
      end

      def functions(stream)
        return if Fx.configuration.disable_functions_dump

        dumpable_functions_in_database.each do |function|
          stream.puts(function.to_schema)
        end
      end

      private

      def dumpable_functions_in_database
        @_dumpable_functions_in_database ||=
          if Fx.configuration.only_dump_these_functions.any?
            Fx.database.functions.select do |function|
              Fx.configuration.only_dump_these_functions.include?(function.name)
            end
          else
            Fx.database.functions
          end
      end
    end
  end
end
