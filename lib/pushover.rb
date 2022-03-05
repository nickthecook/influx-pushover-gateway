# frozen_string_literal: true

require 'httparty'

class Pushover
  class RequestError < StandardError; end

  def push(body)
    response = HTTParty.post(url, body: body, query: { token: token, user: user_token })

    raise RequestError, response["errors"] unless response.success?
  end

  private

  def url
    @url ||= ENV["PUSHOVER_URL"]
  end

  def token
    @token ||= ENV["TOKEN"]
  end

  def user_token
    @user_token ||= ENV["USER_TOKEN"]
  end
end
