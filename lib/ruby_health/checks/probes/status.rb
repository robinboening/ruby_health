# frozen_string_literal: true

module RubyHealth::Checks
  module Probes
    Status = Struct.new(:http_status, :json) do
      # We accept 2xx
      def success?
        http_status / 100 == 2
      end
    end
  end
end
