# frozen_string_literal: true

require_relative 'simple_abstract_check'

module RubyHealth::Checks
  class DbCheck
    extend SimpleAbstractCheck

    class << self
      private

      def successful?(result)
        result == '1'
      end

      def check
        catch_timeout 10.seconds do
          ActiveRecord::Base.connection.execute('SELECT 1 as ping')&.first&.[]('ping')&.to_s
        end
      end
    end
  end
end
