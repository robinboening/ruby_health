# frozen_string_literal: true

require_relative 'base_abstract_check'
require_relative 'result'

module RubyHealth::Checks
  module SimpleAbstractCheck
    include BaseAbstractCheck

    def readiness
      check_result = check
      return if check_result.nil?

      if successful?(check_result)
        RubyHealth::Checks::Result.new(name, true)
      elsif check_result.is_a?(Timeout::Error)
        RubyHealth::Checks::Result.new(name, false, "#{human_name} check timed out")
      else
        RubyHealth::Checks::Result.new(name, false, "unexpected #{human_name} check result: #{check_result}")
      end
    rescue => e
      RubyHealth::Checks::Result.new(name, false, "unexpected #{human_name} check result: #{e}")
    end

    def metrics
      result, elapsed = with_timing(&method(:check))
      return if result.nil?

      Rails.logger.error("#{human_name} check returned unexpected result #{result}") unless successful?(result)
      [
        metric("#{metric_prefix}_timeout", result.is_a?(Timeout::Error) ? 1 : 0),
        metric("#{metric_prefix}_success", successful?(result) ? 1 : 0),
        metric("#{metric_prefix}_latency_seconds", elapsed)
      ]
    end

    private

    def metric_prefix
      raise NotImplementedError
    end

    def successful?(result)
      raise NotImplementedError
    end

    def check
      raise NotImplementedError
    end
  end
end
