# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'json'

require "rack/attack"
use Rack::Attack

require 'active_support'
require 'active_support/cache/memory_store'

class Rack::Attack
  cache.store = ActiveSupport::Cache::MemoryStore.new
end

require_relative 'lib/app'
run App.freeze.app
