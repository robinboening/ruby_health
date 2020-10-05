# frozen_string_literal: true

require_relative 'simple_abstract_check'

module RubyHealth::Checks
  # This check can only be run on Puma `master` process
  class PumaCheck
    extend SimpleAbstractCheck

    class << self
      private

      def successful?(result)
        result > 0
      end

      def check
        stats = Puma.stats
        stats = JSON.parse(stats)

        # If `workers` is missing this means that
        # Puma server is running in single mode
        stats.fetch('workers', 1)
      rescue NoMethodError
        # server is not ready
        0
      end
    end
  end
end
