# frozen_string_literal: true

module RubyHealth::Checks
  Result = Struct.new(:name, :success, :message, :labels) do
    def payload
      {
        status: success ? 'ok' : 'failed',
        message: message,
        labels: labels
      }.compact
    end
  end
end
