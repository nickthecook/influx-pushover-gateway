# frozen_string_literal: true

class ParamValidator
  EXTRA_PARAMS_ERROR = "Unsupported parameters were supplied"

  def initialize(params)
    @params = params
  end

  def valid?
    validation_errors.empty?
  end

  def validation_errors
    @validation_errors ||= begin
      errors = []

      errors << "#{EXTRA_PARAMS_ERROR}: #{@params.join(",")}" if @params.any?

      errors.compact
    end
  end
end
