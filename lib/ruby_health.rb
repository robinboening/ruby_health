require "ruby_health/version"

require 'ruby_health/checks/probes/collection'
require 'ruby_health/checks/db_check'
require 'ruby_health/checks/puma_check'

module RubyHealth
  class Check
    AVAILABLE_CHECKS = [
      Checks::DbCheck,
      Checks::PumaCheck,
    ].freeze

    def initialize(checks = [])
      @checks = AVAILABLE_CHECKS.select { |c| checks.include?(c.name) }
    end

    def call(env)
      result = RubyHealth::Checks::Probes::Collection.new(*@checks).execute
      [result.http_status, { 'Content-Type' => 'application/json' }, ["#{result.json}"]]
    end
  end
end
