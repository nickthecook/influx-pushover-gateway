# frozen_string_literal: true

require 'pry-byebug' if %w[dev test].include? ENV["environment"]

require_relative 'param_validator'
require_relative 'pushover'

class App < Roda
  DEFAULT_LANGUAGE = "en"

  plugin :json

  plugin :error_handler do |e|
    log_exception(e)
    response.status = 500
    ""
  end

  plugin :request_headers

  route do |r|
    r.get "/" do
      response.status = 200
      ""
    end

    if raise_test_exceptions?
      r.post "oops" do
        raise StandardError, "This is a test."
      end
    end

    r.post "notification" do
      validator = ParamValidator.new(r.params)

      log(r.params) if debug?

      if validator.valid?
        notify(r)
        response.status = 204
        nil
      else
        response.status = 400
        validator.validation_errors
      end
    end
  end

  private

  def log(msg)
    $stdout.puts msg
    $stdout.flush
  end

  def log_exception(error)
    $stderr.puts "#{error.class}: #{error}"
    $stderr.puts error.backtrace.join("\n    ") if debug?
  end

  def notify(r)
    incoming = JSON.parse(r.body.read)
    outgoing = JSON.parse(incoming["_message"])

    pushover.push(outgoing)
  end

  def pushover
    @pushover ||= Pushover.new
  end

  def raise_test_exceptions?
    @raise_test_exceptions ||= ENV["RAISE_TEST_EXCEPTIONS"]
  end

  def debug?
    @debug ||= (ENV["DEBUG"] == "true")
  end
end
